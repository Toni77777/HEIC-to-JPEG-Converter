//
//  ConversionResult.swift
//  HEICConverter
//
//  Created by Anton Paliakov on 06/03/2026.
//

import Foundation

struct ConversionResult {
    let sourceURL: URL
    let destinationURL: URL?
    let success: Bool
    let error: ConversionError?

    nonisolated init(
        sourceURL: URL,
        destinationURL: URL? = nil,
        success: Bool,
        error: ConversionError? = nil
    ) {
        self.sourceURL = sourceURL
        self.destinationURL = destinationURL
        self.success = success
        self.error = error
    }
}
