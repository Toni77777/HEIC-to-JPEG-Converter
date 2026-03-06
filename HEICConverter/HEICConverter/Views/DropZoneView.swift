//
//  DropZoneView.swift
//  HEICConverter
//
//  Created by Anton Paliakov on 06/03/2026.
//

import SwiftUI
import UniformTypeIdentifiers

struct DropZoneView: View {
    @Binding var isTargeted: Bool
    let onDrop: ([NSItemProvider]) -> Void
    @Environment(\.accessibilityReduceTransparency) private var reduceTransparency

    var body: some View {
        VStack(spacing: 32) {
            ZStack {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                GlassStyle.accentBlue.opacity(isTargeted ? 0.4 : 0.2),
                                Color.clear
                            ],
                            center: .center,
                            startRadius: 0,
                            endRadius: 80
                        )
                    )
                    .frame(width: 120, height: 120)
                    .blur(radius: 20)

                Image(systemName: "photo.on.rectangle.angled")
                    .font(.system(size: 72, weight: .thin))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [
                                GlassStyle.accentBlue,
                                GlassStyle.accentPurple
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .scaleEffect(isTargeted ? 1.1 : 1.0)
                    .animation(.spring(response: 0.3), value: isTargeted)
            }

            VStack(spacing: 12) {
                Text("Drop HEIC Images Here")
                    .font(.system(size: 28, weight: .semibold, design: .rounded))
                    .foregroundStyle(GlassStyle.textPrimary)

                Text("Supports files and folders")
                    .font(.system(size: 16, weight: .regular))
                    .foregroundStyle(GlassStyle.textSecondary)
            }

            HStack(spacing: 8) {
                Image(systemName: "bolt.fill")
                    .font(.system(size: 12))
                Text("Conversion starts automatically")
                    .font(.system(size: 14, weight: .medium))
            }
            .foregroundStyle(GlassStyle.textSecondary)
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .glassPill()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            let shape = RoundedRectangle(cornerRadius: 24, style: .continuous)

            ZStack {
                if reduceTransparency {
                    shape.fill(GlassStyle.reducedTransparencyFill)
                } else {
                    shape
                        .fill(.ultraThinMaterial)
                        .overlay(
                            shape
                                .fill(GlassStyle.glassBackground)
                                .blendMode(.overlay)
                        )
                }

                if isTargeted {
                    shape
                        .fill(GlassStyle.accentBlue.opacity(0.10))
                        .blendMode(.plusLighter)
                }

                shape
                    .strokeBorder(
                        style: StrokeStyle(
                            lineWidth: 3,
                            lineCap: .round,
                            dash: [15, 10]
                        )
                    )
                    .foregroundStyle(
                        LinearGradient(
                            colors: isTargeted ? [
                                GlassStyle.accentBlue,
                                GlassStyle.accentPurple
                            ] : [
                                GlassStyle.glassBorder,
                                GlassStyle.glassBorder.opacity(0.6)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )

                shape
                    .strokeBorder(
                        LinearGradient(
                            colors: [GlassStyle.glassHighlight, Color.clear],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
                    .blendMode(.screen)
                    .opacity(0.35)
                    .padding(1)
            }
        }
        .padding(32)
        .animation(.easeInOut(duration: 0.3), value: isTargeted)
        .onDrop(of: [UTType.fileURL], isTargeted: $isTargeted) { providers in
            onDrop(providers)
            return true
        }
    }
}
