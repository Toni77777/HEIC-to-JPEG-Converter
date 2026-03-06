//
//  ConversionViewModel.swift
//  HEICConverter
//
//  Created by Anton Paliakov on 06/03/2026.
//

import Foundation
import SwiftUI
import UniformTypeIdentifiers

@Observable
@MainActor
final class ConversionViewModel {

    // MARK: - Properties

    var conversionItems: [ConversionItem] = []
    var isConverting: Bool = false
    var errorMessage: String?
    var showError: Bool = false

    var completedCount: Int {
        conversionItems.filter { $0.state == .completed }.count
    }

    var failedCount: Int {
        conversionItems.filter { $0.state == .failed }.count
    }

    // MARK: - Private

    @ObservationIgnored
    private let conversionService: ImageConversionService

    @ObservationIgnored
    private let fileSystemService: FileSystemService

    @ObservationIgnored
    private let notificationService: NotificationService

    // MARK: - Init

    init(
        conversionService: ImageConversionService = .init(),
        fileSystemService: FileSystemService = .init(),
        notificationService: NotificationService = .init()
    ) {
        self.conversionService = conversionService
        self.fileSystemService = fileSystemService
        self.notificationService = notificationService
    }

    // MARK: - Public

    func handleDrop(providers: [NSItemProvider], settings: ConversionSettings) async {
        guard !isConverting else { return }

        guard settings.customOutputFolder != nil else {
            showErrorAlert("Choose an output folder in Settings → Save Location before converting.")
            return
        }

        var urls: [URL] = []
        for provider in providers {
            if let url = await extractURL(from: provider) {
                urls.append(url)
            }
        }

        guard !urls.isEmpty else { return }

        let heicFiles = await fileSystemService.collectHEICFiles(from: urls)

        guard !heicFiles.isEmpty else {
            showErrorAlert("No HEIC files found in the dropped items")
            return
        }

        var items: [ConversionItem] = []
        for (fileURL, relativePath) in heicFiles {
            do {
                let destinationURL = try await fileSystemService.createDestinationURL(
                    for: fileURL,
                    relativePath: relativePath,
                    settings: settings
                )
                items.append(ConversionItem(
                    sourceURL: fileURL,
                    destinationURL: destinationURL,
                    state: .pending,
                    progress: 0.0,
                    error: nil,
                    relativePath: relativePath
                ))
            } catch {
                items.append(ConversionItem(
                    sourceURL: fileURL,
                    destinationURL: nil,
                    state: .failed,
                    progress: 0.0,
                    error: error as? ConversionError ?? .unknownError(error.localizedDescription),
                    relativePath: relativePath
                ))
            }
        }

        conversionItems = items
        await startConversion(settings: settings)
    }

    func startConversion(settings: ConversionSettings) async {
        guard !isConverting, !conversionItems.isEmpty else { return }

        isConverting = true
        defer { isConverting = false }

        let itemsToConvert = conversionItems.enumerated().compactMap { index, item -> (index: Int, source: URL, destination: URL)? in
            guard item.state == .pending || item.state == .failed,
                  let destination = item.destinationURL else { return nil }
            return (index, item.sourceURL, destination)
        }

        for (index, _, _) in itemsToConvert {
            conversionItems[index].state = .converting
        }

        // Capture indices before the async boundary so the progress closure
        // always updates the correct item regardless of array mutations.
        let batchItems = itemsToConvert.map { (source: $0.source, destination: $0.destination) }
        let convItemsIndices = itemsToConvert.map(\.index)

        let results = await conversionService.convertBatch(
            items: batchItems,
            quality: settings.quality
        ) { [weak self] batchIndex, progress in
            guard let self else { return }
            let itemIndex = convItemsIndices[batchIndex]
            guard itemIndex < self.conversionItems.count else { return }
            self.conversionItems[itemIndex].progress = progress
        }

        for (itemIndex, result) in zip(itemsToConvert.map(\.index), results) {
            if result.success {
                conversionItems[itemIndex].state = .completed
                conversionItems[itemIndex].progress = 1.0
            } else {
                conversionItems[itemIndex].state = .failed
                conversionItems[itemIndex].error = result.error
            }
        }

        if settings.notifyOnCompletion {
            await notificationService.sendCompletionNotification(
                successCount: completedCount,
                failCount: failedCount
            )
        }
    }

    func clearItems() {
        conversionItems.removeAll()
    }

    // MARK: - Private

    private func extractURL(from provider: NSItemProvider) async -> URL? {
        let fileURLType = UTType.fileURL.identifier
        guard provider.hasItemConformingToTypeIdentifier(fileURLType) else { return nil }

        return await withCheckedContinuation { continuation in
            provider.loadItem(forTypeIdentifier: fileURLType, options: nil) { item, _ in
                if let data = item as? Data, let url = URL(dataRepresentation: data, relativeTo: nil) {
                    continuation.resume(returning: url)
                } else if let url = item as? URL {
                    continuation.resume(returning: url)
                } else {
                    continuation.resume(returning: nil)
                }
            }
        }
    }

    private func showErrorAlert(_ message: String) {
        errorMessage = message
        showError = true
    }
}
