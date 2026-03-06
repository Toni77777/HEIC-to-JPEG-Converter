//
//  QualitySliderView.swift
//  HEICConverter
//
//  Created by Anton Paliakov on 06/03/2026.
//

import SwiftUI

struct QualitySliderView: View {
    @Binding var quality: Double
    @Environment(\.accessibilityReduceTransparency) private var reduceTransparency

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "sparkles")
                    .font(.system(size: 14))
                    .foregroundStyle(GlassStyle.accentGradient)

                Text("Quality")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(GlassStyle.textPrimary)

                Spacer()

                Text("\(Int(quality * 100))%")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundStyle(GlassStyle.accentGradient)
                    .monospacedDigit()
            }

            GeometryReader { geometry in
                let normalized = min(max((quality - 0.6) / 0.4, 0), 1)

                ZStack(alignment: .leading) {
                    ZStack {
                        if reduceTransparency {
                            Capsule().fill(GlassStyle.reducedTransparencyFill)
                        } else {
                            Capsule().fill(.ultraThinMaterial)
                        }
                    }
                    .overlay(
                        Capsule()
                            .fill(GlassStyle.glassBackground)
                            .blendMode(.overlay)
                    )
                    .overlay(
                        Capsule()
                            .strokeBorder(GlassStyle.glassBorder, lineWidth: 1)
                    )
                    .frame(height: 8)

                    Capsule()
                        .fill(
                            LinearGradient(
                                colors: [
                                    GlassStyle.accentBlue,
                                    GlassStyle.accentPurple
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: CGFloat(normalized) * geometry.size.width, height: 8)
                        .shadow(color: GlassStyle.accentBlue.opacity(0.5), radius: 8, x: 0, y: 2)

                    ZStack {
                        if reduceTransparency {
                            Circle().fill(GlassStyle.reducedTransparencyFill)
                        } else {
                            Circle().fill(.ultraThinMaterial)
                        }
                    }
                    .overlay(
                        Circle()
                            .fill(GlassStyle.glassBackground)
                            .blendMode(.overlay)
                    )
                    .frame(width: 24, height: 24)
                    .overlay(
                        Circle()
                            .strokeBorder(GlassStyle.accentGradient, lineWidth: 2)
                    )
                    .overlay(
                        Circle()
                            .strokeBorder(
                                LinearGradient(
                                    colors: [GlassStyle.glassHighlight, Color.clear],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1
                            )
                            .blendMode(.screen)
                            .opacity(0.7)
                            .padding(0.5)
                    )
                    .shadow(color: .black.opacity(0.3), radius: 4, x: 0, y: 2)
                    .offset(x: CGFloat(normalized) * (geometry.size.width - 24))
                }
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            let percent = min(max(0, value.location.x / geometry.size.width), 1)
                            quality = 0.6 + (percent * 0.4)
                            // Round to nearest 0.05
                            quality = round(quality * 20) / 20
                        }
                )
            }
            .frame(height: 24)

            HStack {
                Label("Smaller", systemImage: "arrow.down.circle.fill")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(GlassStyle.textSecondary)

                Spacer()

                Label("Larger", systemImage: "arrow.up.circle.fill")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(GlassStyle.textSecondary)
            }
        }
        .padding(20)
        .glassCard(cornerRadius: 20)
    }
}
