//
//  URL+Extensions.swift
//  HEICConverter
//
//  Created by Anton Paliakov on 06/03/2026.
//

import Foundation

extension URL {
    
    /// Returns true if the file is a HEIC or HEIF image
    nonisolated var isHEICFile: Bool {
        let ext = pathExtension.lowercased()
        return ext == "heic" || ext == "heif"
    }
    
    /// Accesses a security-scoped resource and performs an operation
    nonisolated func accessSecurityScopedResource<T>(_ operation: () throws -> T) throws -> T {
        let didStartAccessing = startAccessingSecurityScopedResource()
        defer {
            if didStartAccessing {
                stopAccessingSecurityScopedResource()
            }
        }
        return try operation()
    }

    /// Accesses a security-scoped resource and performs an async operation
    nonisolated func accessSecurityScopedResource<T>(_ operation: () async throws -> T) async throws -> T {
        let didStartAccessing = startAccessingSecurityScopedResource()
        defer {
            if didStartAccessing {
                stopAccessingSecurityScopedResource()
            }
        }
        return try await operation()
    }

    /// Returns the relative path from a base URL
    nonisolated func relativePath(from baseURL: URL) -> String? {
        guard isFileURL, baseURL.isFileURL else { return nil }

        let baseComponents = baseURL.standardizedFileURL.pathComponents
        let fullComponents = standardizedFileURL.pathComponents

        guard fullComponents.starts(with: baseComponents) else { return nil }

        let relativeComponents = fullComponents.dropFirst(baseComponents.count)
        guard !relativeComponents.isEmpty else { return nil }

        return relativeComponents.joined(separator: "/")
    }
}
