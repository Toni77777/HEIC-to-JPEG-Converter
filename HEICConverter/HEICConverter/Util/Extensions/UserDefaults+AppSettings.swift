//
//  UserDefaults+AppSettings.swift
//  HEICConverter
//
//  Created by Anton Paliakov on 06/03/2026.
//

import Foundation

extension UserDefaults {
    private enum Keys {
        static let conversionQuality = "conversionQuality"
        static let notifyOnCompletion = "notifyOnCompletion"
        static let outputFolderBookmark = "outputFolderBookmark"
    }

    var conversionQuality: Double {
        get { object(forKey: Keys.conversionQuality) as? Double ?? 0.85 }
        set { set(newValue, forKey: Keys.conversionQuality) }
    }

    var notifyOnCompletion: Bool {
        get { bool(forKey: Keys.notifyOnCompletion) }
        set { set(newValue, forKey: Keys.notifyOnCompletion) }
    }

    var outputFolderBookmark: Data? {
        get { data(forKey: Keys.outputFolderBookmark) }
        set { set(newValue, forKey: Keys.outputFolderBookmark) }
    }
}
