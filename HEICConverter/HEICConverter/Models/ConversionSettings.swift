//
//  ConversionSettings.swift
//  HEICConverter
//
//  Created by Anton Paliakov on 06/03/2026.
//

import Foundation

struct ConversionSettings {
    let quality: Double
    let customOutputFolder: URL?
    let notifyOnCompletion: Bool

    init(
        quality: Double = 0.85,
        customOutputFolder: URL? = nil,
        notifyOnCompletion: Bool = false
    ) {
        self.quality = quality
        self.customOutputFolder = customOutputFolder
        self.notifyOnCompletion = notifyOnCompletion
    }
}
