//
//  GlassStyle.swift
//  HEICConverter
//
//  Created by Anton Paliakov on 06/03/2026.
//

import AppKit
import SwiftUI

enum GlassStyle {
    static let darkBackground = Color(nsColor: .windowBackgroundColor)

    static let glassBackground = Color.primary.opacity(0.06)
    static let glassBorder = Color.primary.opacity(0.14)
    static let glassHighlight = Color.white.opacity(0.28)

    static let textPrimary = Color.primary
    static let textSecondary = Color.secondary

    static let accentBlue = Color(red: 0.4, green: 0.6, blue: 1.0)
    static let accentPurple = Color(red: 0.6, green: 0.4, blue: 1.0)

    static let accentGradient = LinearGradient(
        colors: [accentBlue, accentPurple],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let reducedTransparencyFill = Color(nsColor: .controlBackgroundColor)
}

struct GlassCardModifier: ViewModifier {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.accessibilityReduceTransparency) private var reduceTransparency

    let cornerRadius: CGFloat

    func body(content: Content) -> some View {
        content
            .background {
                let shape = RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)

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

                    shape
                        .strokeBorder(GlassStyle.glassBorder, lineWidth: 1)

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
                        .opacity(0.75)
                        .padding(0.5)
                }
            }
            .shadow(
                color: Color.black.opacity(colorScheme == .dark ? 0.35 : 0.12),
                radius: 24,
                x: 0,
                y: 12
            )
    }
}

struct GlassPillModifier: ViewModifier {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.accessibilityReduceTransparency) private var reduceTransparency

    func body(content: Content) -> some View {
        content
            .background {
                let shape = Capsule()

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

                    shape
                        .strokeBorder(GlassStyle.glassBorder, lineWidth: 1)

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
                        .opacity(0.65)
                        .padding(0.5)
                }
            }
    }
}

extension View {
    func glassCard(cornerRadius: CGFloat = 16) -> some View {
        modifier(GlassCardModifier(cornerRadius: cornerRadius))
    }

    func glassPill() -> some View {
        modifier(GlassPillModifier())
    }
}
