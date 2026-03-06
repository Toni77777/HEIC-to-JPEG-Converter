//
//  ConversionItemRow.swift
//  HEICConverter
//
//  Created by Anton Paliakov on 06/03/2026.
//

import SwiftUI

struct ConversionItemRow: View {
    let item: ConversionItem
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.accessibilityReduceTransparency) private var reduceTransparency

    var body: some View {
        HStack(spacing: 16) {
            statusIcon
                .frame(width: 32, height: 32)

            VStack(alignment: .leading, spacing: 6) {
                Text(item.sourceURL.lastPathComponent)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(GlassStyle.textPrimary)
                    .lineLimit(1)

                if let relativePath = item.relativePath, !relativePath.isEmpty {
                    HStack(spacing: 4) {
                        Image(systemName: "folder.fill")
                            .font(.system(size: 10))
                        Text(relativePath)
                            .font(.system(size: 11, weight: .regular))
                    }
                    .foregroundStyle(GlassStyle.textSecondary)
                    .lineLimit(1)
                }

                // Error message
                if let error = item.error {
                    HStack(spacing: 4) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .font(.system(size: 10))
                        Text(error.localizedDescription)
                            .font(.system(size: 11, weight: .medium))
                    }
                    .foregroundStyle(.red.opacity(0.9))
                    .lineLimit(2)
                }
            }

            Spacer()
            
            if item.state == .converting {
                VStack(alignment: .trailing, spacing: 8) {
                    // Circular progress indicator
                    ZStack {
                        Circle()
                            .stroke(GlassStyle.glassBorder, lineWidth: 3)
                            .frame(width: 36, height: 36)

                        Circle()
                            .trim(from: 0, to: item.progress)
                            .stroke(
                                LinearGradient(
                                    colors: [
                                        GlassStyle.accentBlue,
                                        GlassStyle.accentPurple
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                style: StrokeStyle(lineWidth: 3, lineCap: .round)
                            )
                            .frame(width: 36, height: 36)
                            .rotationEffect(.degrees(-90))
                            .animation(.linear(duration: 0.3), value: item.progress)

                        Text("\(Int(item.progress * 100))")
                            .font(.system(size: 11, weight: .bold, design: .rounded))
                            .foregroundStyle(GlassStyle.accentGradient)
                            .monospacedDigit()
                    }
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background {
            let shape = RoundedRectangle(cornerRadius: 14, style: .continuous)

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

                switch item.state {
                case .completed:
                    shape
                        .fill(Color.green.opacity(0.12))
                        .blendMode(.plusLighter)
                    shape
                        .strokeBorder(Color.green.opacity(0.30), lineWidth: 1)
                case .failed:
                    shape
                        .fill(Color.red.opacity(0.10))
                        .blendMode(.plusLighter)
                    shape
                        .strokeBorder(Color.red.opacity(0.30), lineWidth: 1)
                default:
                    shape
                        .strokeBorder(GlassStyle.glassBorder, lineWidth: 1)
                }

                shape
                    .strokeBorder(
                        LinearGradient(
                            colors: [GlassStyle.glassHighlight, Color.clear],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
                    .blendMode(colorScheme == .dark ? .screen : .overlay)
                    .opacity(0.55)
                    .padding(0.5)
            }
        }
        .shadow(
            color: Color.black.opacity(colorScheme == .dark ? 0.16 : 0.06),
            radius: 12,
            x: 0,
            y: 6
        )
    }

    @ViewBuilder
    private var statusIcon: some View {
        switch item.state {
        case .pending:
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
                .overlay(
                    Circle()
                        .strokeBorder(GlassStyle.glassBorder, lineWidth: 1)
                )
            Image(systemName: "clock.fill")
                .font(.system(size: 14))
                .foregroundStyle(.orange.opacity(0.8))

        case .converting:
            ProgressView()
                .controlSize(.regular)
                .tint(.accentColor)

        case .completed:
            ZStack {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [Color.green.opacity(0.3), Color.green.opacity(0.1)],
                            center: .center,
                            startRadius: 0,
                            endRadius: 16
                        )
                    )

                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 24))
                    .foregroundStyle(.green)
                    .shadow(color: .green.opacity(0.3), radius: 4)
            }

        case .failed:
            ZStack {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [Color.red.opacity(0.3), Color.red.opacity(0.1)],
                            center: .center,
                            startRadius: 0,
                            endRadius: 16
                        )
                    )

                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 24))
                    .foregroundStyle(.red)
                    .shadow(color: .red.opacity(0.3), radius: 4)
            }
        }
    }
}
