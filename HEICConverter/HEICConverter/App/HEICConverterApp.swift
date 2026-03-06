//
//  HEICConverterApp.swift
//  HEICConverter
//
//  Created by Anton Paliakov on 06/03/2026.
//

import SwiftUI

@main
struct HEICConverterApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView()
                .frame(width: 850, height: 750)
        }
        .windowToolbarLabelStyle(fixed: .titleOnly)
        .windowResizability(.contentSize)
    }
}
