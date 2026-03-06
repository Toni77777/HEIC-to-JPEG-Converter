//
//  SectionHeader.swift
//  HEICConverter
//
//  Created by Anton Paliakov on 06/03/2026.
//

import SwiftUI

struct SectionHeader: View {
    let icon: String
    let title: String

    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.system(size: 14))
                .foregroundStyle(GlassStyle.accentGradient)

            Text(title)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(GlassStyle.textPrimary)
        }
    }
}
