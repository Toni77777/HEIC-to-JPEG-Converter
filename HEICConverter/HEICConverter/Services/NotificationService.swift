//
//  NotificationService.swift
//  HEICConverter
//
//  Created by Anton Paliakov on 06/03/2026.
//

import Foundation
@preconcurrency import UserNotifications
import AppKit

final class NotificationService {

    // MARK: - Public

    @MainActor
    func sendCompletionNotification(successCount: Int, failCount: Int) async {
        let status = await authorizationStatus()
        guard status.canPostNotifications else { return }

        let content = UNMutableNotificationContent()
        content.title = "Conversion Complete"
        content.body = failCount > 0
            ? "\(successCount) files converted successfully, \(failCount) failed"
            : "\(successCount) files converted successfully"
        content.sound = .default

        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: nil
        )

        try? await UNUserNotificationCenter.current().add(request)
        NSApp.requestUserAttention(.informationalRequest)
    }

    @MainActor
    func enableCompletionNotifications() async -> Bool {
        let status = await authorizationStatus()
        switch status {
        case .authorized, .provisional, .ephemeral:
            return true
        case .notDetermined:
            return (try? await UNUserNotificationCenter.current()
                .requestAuthorization(options: [.alert, .sound, .badge])) ?? false
        case .denied:
            return false
        @unknown default:
            return false
        }
    }
    
    func openNotificationSettings() {
        guard let url = URL(string: "x-apple.systempreferences:com.apple.preference.notifications") else { return }
        NSWorkspace.shared.open(url)
    }

    // MARK: - Private

    @MainActor
    private func authorizationStatus() async -> UNAuthorizationStatus {
        await UNUserNotificationCenter.current().notificationSettings().authorizationStatus
    }
}
