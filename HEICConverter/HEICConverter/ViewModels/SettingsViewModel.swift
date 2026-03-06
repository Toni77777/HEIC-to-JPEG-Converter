//
//  SettingsViewModel.swift
//  HEICConverter
//
//  Created by Anton Paliakov on 06/03/2026.
//

import Foundation
import SwiftUI
import AppKit

@Observable
@MainActor
final class SettingsViewModel {

    // MARK: - Properties

    var quality: Double = UserDefaults.standard.conversionQuality {
        didSet {
            UserDefaults.standard.conversionQuality = quality
        }
    }

    var notifyOnCompletion: Bool = UserDefaults.standard.notifyOnCompletion {
        didSet {
            UserDefaults.standard.notifyOnCompletion = notifyOnCompletion
        }
    }

    var customOutputFolder: URL?

    var settings: ConversionSettings {
        ConversionSettings(
            quality: quality,
            customOutputFolder: customOutputFolder,
            notifyOnCompletion: notifyOnCompletion
        )
    }

    // MARK: - Private

    @ObservationIgnored
    private var scopedURL: URL?

    @ObservationIgnored
    private let notificationService: NotificationService

    // MARK: - Init

    init(notificationService: NotificationService = .init()) {
        self.notificationService = notificationService
        if let url = Self.restoreOutputFolder() {
            customOutputFolder = url
            if url.startAccessingSecurityScopedResource() {
                scopedURL = url
            }
        }
    }

    deinit {
        scopedURL?.stopAccessingSecurityScopedResource()
    }

    // MARK: - Notifications

    func enableNotifications() async -> Bool {
        await notificationService.enableCompletionNotifications()
    }

    func openNotificationSettings() {
        notificationService.openNotificationSettings()
    }

    // MARK: - Folder Selection

    func selectCustomFolder() {
        let panel = NSOpenPanel()
        panel.canChooseFiles = false
        panel.canChooseDirectories = true
        panel.canCreateDirectories = true
        panel.allowsMultipleSelection = false
        panel.message = "Select a folder for converted images"

        panel.begin { [weak self] response in
            guard response == .OK, let url = panel.url else { return }
            self?.scopedURL?.stopAccessingSecurityScopedResource()
            self?.customOutputFolder = url
            self?.scopedURL = url.startAccessingSecurityScopedResource() ? url : nil
            self?.saveOutputFolder(url)
        }
    }

    // MARK: - Persistence

    private func saveOutputFolder(_ url: URL) {
        UserDefaults.standard.outputFolderBookmark = try? url.bookmarkData(
            options: .withSecurityScope,
            includingResourceValuesForKeys: nil,
            relativeTo: nil
        )
    }

    private static func restoreOutputFolder() -> URL? {
        guard let bookmark = UserDefaults.standard.outputFolderBookmark else { return nil }

        var isStale = false
        guard let url = try? URL(
            resolvingBookmarkData: bookmark,
            options: .withSecurityScope,
            relativeTo: nil,
            bookmarkDataIsStale: &isStale
        ) else {
            UserDefaults.standard.outputFolderBookmark = nil
            return nil
        }

        if isStale {
            let refreshedBookmark = try? url.bookmarkData(
                options: .withSecurityScope,
                includingResourceValuesForKeys: nil,
                relativeTo: nil
            )
            if let refreshedBookmark {
                UserDefaults.standard.outputFolderBookmark = refreshedBookmark
            }
        }

        return url
    }
}
