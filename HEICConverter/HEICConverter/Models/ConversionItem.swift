//
//  ConversionItem.swift
//  HEICConverter
//
//  Created by Anton Paliakov on 06/03/2026.
//

import Foundation

struct ConversionItem: Identifiable {
    let id = UUID()
    let sourceURL: URL
    var destinationURL: URL?
    var state: ConversionState
    var progress: Double
    var error: ConversionError?
    let relativePath: String?

    init(
        sourceURL: URL,
        destinationURL: URL? = nil,
        state: ConversionState = .pending,
        progress: Double = 0.0,
        error: ConversionError? = nil,
        relativePath: String? = nil
    ) {
        self.sourceURL = sourceURL
        self.destinationURL = destinationURL
        self.state = state
        self.progress = progress
        self.error = error
        self.relativePath = relativePath
    }
}

extension ConversionItem {
    enum ConversionState: Equatable {
        case pending
        case converting
        case completed
        case failed
    }
}
