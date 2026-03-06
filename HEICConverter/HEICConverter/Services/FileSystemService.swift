//
//  FileSystemService.swift
//  HEICConverter
//
//  Created by Anton Paliakov on 06/03/2026.
//

import Foundation

actor FileSystemService {
    private let fileManager = FileManager.default

    /// Collects all HEIC files from the provided URLs (files or directories).
    func collectHEICFiles(from urls: [URL]) async -> [(url: URL, relativePath: String?)] {
        urls.flatMap { url -> [(url: URL, relativePath: String?)] in
            var isDirectory: ObjCBool = false
            guard fileManager.fileExists(atPath: url.path, isDirectory: &isDirectory) else { return [] }

            if isDirectory.boolValue {
                return collectHEICFilesRecursively(from: url, baseURL: url)
            } else if url.isHEICFile {
                return [(url, nil)]
            }
            return []
        }
    }

    /// Recursively collects HEIC files from a directory.
    private func collectHEICFilesRecursively(from directory: URL, baseURL: URL) -> [(url: URL, relativePath: String?)] {
        guard let enumerator = fileManager.enumerator(
            at: directory,
            includingPropertiesForKeys: [.isDirectoryKey],
            options: .skipsHiddenFiles
        ) else { return [] }

        return enumerator
            .compactMap { $0 as? URL }
            .filter { url in
                let isDirectory = (try? url.resourceValues(forKeys: [.isDirectoryKey]))?.isDirectory ?? false
                return !isDirectory && url.isHEICFile
            }
            .map { ($0, $0.relativePath(from: baseURL)) }
    }

    /// Creates the destination URL for a converted file, creating intermediate directories as needed.
    func createDestinationURL(
        for sourceURL: URL,
        relativePath: String?,
        settings: ConversionSettings
    ) async throws -> URL {
        guard let outputFolder = settings.customOutputFolder else {
            throw ConversionError.fileWriteError("No output folder selected")
        }

        var directory = outputFolder

        if let relativePath {
            let subdirectory = (relativePath as NSString).deletingLastPathComponent
            if !subdirectory.isEmpty {
                directory = directory.appendingPathComponent(subdirectory)
            }
        }

        try fileManager.createDirectory(at: directory, withIntermediateDirectories: true)

        let filename = sourceURL.deletingPathExtension().lastPathComponent
        return resolveNameConflict(for: directory.appendingPathComponent("\(filename).jpg"))
    }

    /// Appends a counter suffix to avoid overwriting existing files.
    private func resolveNameConflict(for url: URL) -> URL {
        guard fileManager.fileExists(atPath: url.path) else { return url }

        let stem = url.deletingPathExtension().lastPathComponent
        let directory = url.deletingLastPathComponent()

        for counter in 2... {
            let candidate = directory.appendingPathComponent("\(stem) (\(counter)).jpg")
            if !fileManager.fileExists(atPath: candidate.path) {
                return candidate
            }
        }

        return url
    }
}
