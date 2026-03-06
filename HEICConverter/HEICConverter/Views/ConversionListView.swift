//
//  ConversionListView.swift
//  HEICConverter
//
//  Created by Anton Paliakov on 06/03/2026.
//

import SwiftUI

struct ConversionListView: View {
    var viewModel: ConversionViewModel

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 8) {
                        Image(systemName: "photo.stack.fill")
                            .font(.system(size: 16))
                            .foregroundStyle(GlassStyle.accentGradient)

                        Text("\(viewModel.conversionItems.count) files")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundStyle(GlassStyle.textPrimary)
                    }

                    HStack(spacing: 16) {
                        if viewModel.completedCount > 0 {
                            HStack(spacing: 6) {
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.system(size: 12))
                                Text("\(viewModel.completedCount) completed")
                                    .font(.system(size: 13, weight: .medium))
                            }
                            .foregroundStyle(.green.opacity(0.9))
                        }

                        if viewModel.failedCount > 0 {
                            HStack(spacing: 6) {
                                Image(systemName: "xmark.circle.fill")
                                    .font(.system(size: 12))
                                Text("\(viewModel.failedCount) failed")
                                    .font(.system(size: 13, weight: .medium))
                            }
                            .foregroundStyle(.red.opacity(0.9))
                        }
                    }
                }

                Spacer()

                Button(action: {
                    withAnimation(.spring(response: 0.3)) {
                        viewModel.clearItems()
                    }
                }) {
                    HStack(spacing: 8) {
                        Image(systemName: "trash.fill")
                            .font(.system(size: 13))
                        Text("Clear")
                            .font(.system(size: 14, weight: .semibold))
                    }
                    .foregroundStyle(GlassStyle.textPrimary)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .glassPill()
                }
                .buttonStyle(.plain)
                .disabled(viewModel.isConverting)
                .opacity(viewModel.isConverting ? 0.5 : 1.0)
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

            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(viewModel.conversionItems) { item in
                        ConversionItemRow(item: item)
                            .transition(.scale.combined(with: .opacity))
                    }
                }
                .padding(24)
            }
            .background {
                Rectangle()
                    .fill(.ultraThinMaterial)
                    .overlay(
                        Rectangle()
                            .fill(GlassStyle.glassBackground.opacity(0.5))
                            .blendMode(.overlay)
                    )
            }
        }
    }
}
