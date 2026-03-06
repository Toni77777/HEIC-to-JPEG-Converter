//
//  SettingsPanel.swift
//  HEICConverter
//
//  Created by Anton Paliakov on 06/03/2026.
//

import SwiftUI

struct SettingsPanel: View {
    @Bindable var viewModel: SettingsViewModel

    var body: some View {
        HStack(spacing: 20) {
            QualitySliderView(quality: $viewModel.quality)
                .frame(maxWidth: 450)

            Rectangle()
                .fill(GlassStyle.glassBorder)
                .frame(width: 1)
                .frame(maxHeight: 100)

            SaveLocationSection(viewModel: viewModel)
                .padding(20)
                .glassCard(cornerRadius: 20)

            Spacer()
        }
        .padding(24)
        .background {
            Rectangle()
                .fill(.ultraThinMaterial)
                .overlay(
                    Rectangle()
                        .fill(GlassStyle.glassBackground)
                        .blendMode(.overlay)
                )
                .overlay(alignment: .bottom) {
                    Rectangle()
                        .fill(GlassStyle.glassBorder)
                        .frame(height: 1)
                }
        }
    }
}

#Preview {
    ZStack {
        GlassStyle.darkBackground
            .ignoresSafeArea()

        SettingsPanel(viewModel: SettingsViewModel())
    }
}
