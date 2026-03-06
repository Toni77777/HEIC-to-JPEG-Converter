//
//  UNAuthorizationStatus+Extensions.swift
//  HEICConverter
//
//  Created by Anton Paliakov on 06/03/2026.
//

import UserNotifications

extension UNAuthorizationStatus {
    var canPostNotifications: Bool {
        switch self {
        case .authorized, .provisional, .ephemeral:
            return true
        case .notDetermined, .denied:
            return false
        @unknown default:
            return false
        }
    }
}
