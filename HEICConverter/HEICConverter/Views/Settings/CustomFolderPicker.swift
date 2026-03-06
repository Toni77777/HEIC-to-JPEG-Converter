//
//  CustomFolderPicker.swift
//  HEICConverter
//
//  Created by Anton Paliakov on 06/03/2026.
//

import SwiftUI

struct CustomFolderPicker: View {
    let folder: URL?
    let onSelect: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let folder {
                HStack(spacing: 8) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 12))
                        .foregroundStyle(.green)

                    Text(folder.path(percentEncoded: false))
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(GlassStyle.textSecondary)
                        .lineLimit(2)
                        .truncationMode(.middle)
                }
            } else {
                HStack(spacing: 8) {
                    Image(systemName: "exclamationmark.circle.fill")
                        .font(.system(size: 12))
                        .foregroundStyle(.red)

                    Text("No folder selected")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(.red.opacity(0.8))
                }
            }

            Button(action: onSelect) {
                HStack(spacing: 8) {
                    Image(systemName: "folder.badge.plus")
                        .font(.system(size: 13))

                    Text("Choose Folder")
                        .font(.system(size: 13, weight: .semibold))
                }
                .foregroundStyle(GlassStyle.textPrimary)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .glassPill()
            }
            .buttonStyle(.plain)
        }
    }
}
