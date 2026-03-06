//
//  FooterView.swift
//  HEICConverter
//
//  Created by Anton Paliakov on 06/03/2026.
//

import SwiftUI

struct FooterView: View {
    var body: some View {
        HStack(spacing: 4) {
            Text("Made with")
            Image(systemName: "heart.fill")
                .foregroundStyle(GlassStyle.accentGradient)
                .imageScale(.small)
            Text("by Anton Paliakou · Gdańsk, Poland")
        }
        .font(.system(size: 11, weight: .regular))
        .foregroundStyle(GlassStyle.textSecondary)
    }
}
