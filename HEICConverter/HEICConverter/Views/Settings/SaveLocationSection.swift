//
//  SaveLocationSection.swift
//  HEICConverter
//
//  Created by Anton Paliakov on 06/03/2026.
//

import SwiftUI

struct SaveLocationSection: View {
    @Bindable var viewModel: SettingsViewModel
    @State private var showNotificationsSettingsAlert = false

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            SectionHeader(icon: "folder.fill", title: "Save Location")

            CustomFolderPicker(
                folder: viewModel.customOutputFolder,
                onSelect: { viewModel.selectCustomFolder() }
            )

            Rectangle()
                .fill(GlassStyle.glassBorder)
                .frame(height: 1)
                .padding(.top, 8)

            NotificationsSection(
                viewModel: viewModel,
                showSettingsAlert: $showNotificationsSettingsAlert
            )
        }
        .alert("Notifications are disabled", isPresented: $showNotificationsSettingsAlert) {
            Button("Open System Settings") {
                viewModel.openNotificationSettings()
            }
            Button("OK", role: .cancel) {}
        } message: {
            Text("To get completion alerts, enable notifications for ImageConverterPrivate in System Settings → Notifications.")
        }
    }
}
