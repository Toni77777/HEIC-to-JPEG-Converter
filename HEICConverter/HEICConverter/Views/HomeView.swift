//
//  HomeView.swift
//  HEICConverter
//
//  Created by Anton Paliakov on 06/03/2026.
//

import SwiftUI

struct HomeView: View {
    @State private var conversionViewModel = ConversionViewModel()
    @State private var settingsViewModel = SettingsViewModel()
    @State private var isDropTargeted = false
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        ZStack {
            Rectangle()
                .fill(.regularMaterial)
                .ignoresSafeArea()

            LinearGradient(
                colors: [
                    Color(red: 0.25, green: 0.45, blue: 1.0),
                    Color(red: 0.65, green: 0.35, blue: 1.0),
                    Color(red: 0.15, green: 0.75, blue: 0.95)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .opacity(colorScheme == .dark ? 0.22 : 0.12)
            .blendMode(colorScheme == .dark ? .plusLighter : .overlay)
            .ignoresSafeArea()

            // Liquid color orbs for depth
            GeometryReader { geometry in
                ZStack {
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [
                                    Color(red: 0.35, green: 0.6, blue: 1.0).opacity(colorScheme == .dark ? 0.18 : 0.10),
                                    Color.clear
                                ],
                                center: .center,
                                startRadius: 0,
                                endRadius: 200
                            )
                        )
                        .frame(width: 400, height: 400)
                        .offset(x: geometry.size.width * 0.8, y: geometry.size.height * 0.2)
                        .blur(radius: 70)

                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [
                                    Color(red: 0.7, green: 0.4, blue: 1.0).opacity(colorScheme == .dark ? 0.14 : 0.08),
                                    Color.clear
                                ],
                                center: .center,
                                startRadius: 0,
                                endRadius: 200
                            )
                        )
                        .frame(width: 350, height: 350)
                        .offset(x: geometry.size.width * 0.1, y: geometry.size.height * 0.7)
                        .blur(radius: 70)
                }
                .blendMode(colorScheme == .dark ? .plusLighter : .overlay)
            }
            .allowsHitTesting(false)

            VStack(spacing: 0) {
                SettingsPanel(viewModel: settingsViewModel)

                if conversionViewModel.conversionItems.isEmpty {
                    DropZoneView(isTargeted: $isDropTargeted) { providers in
                        Task {
                            await conversionViewModel.handleDrop(
                                providers: providers,
                                settings: settingsViewModel.settings
                            )
                        }
                    }
                } else {
                    ConversionListView(viewModel: conversionViewModel)
                }
            }

            VStack {
                Spacer()
                HStack {
                    Spacer()
                    FooterView()
                }
                .padding(.bottom, 10)
                .padding(.horizontal, 32)
            }
        }
        .alert("Error", isPresented: $conversionViewModel.showError) {
            Button("OK") {
                conversionViewModel.showError = false
            }
        } message: {
            if let errorMessage = conversionViewModel.errorMessage {
                Text(errorMessage)
            }
        }
    }
}

#Preview {
    HomeView()
}
