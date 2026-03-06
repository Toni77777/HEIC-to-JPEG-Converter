//
//  ConversionError.swift
//  HEICConverter
//
//  Created by Anton Paliakov on 06/03/2026.
//

import Foundation

enum ConversionError: Error, LocalizedError {
    case invalidFileFormat(String)
    case fileReadError(String)
    case fileWriteError(String)
    case conversionFailed(String)
    case permissionDenied(String)
    case unknownError(String)

    var errorDescription: String? {
        switch self {
        case .invalidFileFormat(let filename):
            return "Invalid file format: \(filename)"
        case .fileReadError(let filename):
            return "Cannot read file: \(filename)"
        case .fileWriteError(let filename):
            return "Cannot write file: \(filename)"
        case .conversionFailed(let filename):
            return "Conversion failed: \(filename)"
        case .permissionDenied(let filename):
            return "Permission denied: \(filename)"
        case .unknownError(let message):
            return "Unknown error: \(message)"
        }
    }
}
