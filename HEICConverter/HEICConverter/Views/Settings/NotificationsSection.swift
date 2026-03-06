//
//  NotificationsSection.swift
//  HEICConverter
//
//  Created by Anton Paliakov on 06/03/2026.
//

import SwiftUI

struct NotificationsSection: View {
    @Bindable var viewModel: SettingsViewModel
    @Binding var showSettingsAlert: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            SectionHeader(icon: "bell.badge.fill", title: "Notifications")

            Toggle(isOn: Binding(
                get: { viewModel.notifyOnCompletion },
                set: { newValue in
                    if !newValue {
                        viewModel.notifyOnCompletion = false
                        return
                    }
                    Task { @MainActor in
                        viewModel.notifyOnCompletion = true
                        let enabled = await viewModel.enableNotifications()
                        if !enabled {
                            viewModel.notifyOnCompletion = false
                            showSettingsAlert = true
                        }
                    }
                }
            )) {
                Text("Notify when finished")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(GlassStyle.textPrimary)
            }
            .toggleStyle(.switch)

            Text("Get a macOS notification when conversion finishes.")
                .font(.system(size: 12, weight: .regular))
                .foregroundStyle(GlassStyle.textSecondary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}
