//
//  BenchKitPrimaryButton.swift
//  BenchKit
//
//  Created by Kuba on 10/11/24.
//

import SwiftUI
struct BenchKitPrimaryButton: ButtonStyle {
    @Environment(\.isEnabled) var isEnabled
    
    func makeBody(configuration: Configuration) -> some View {
        configuration
            .label
            .padding(.horizontal, 15)
            .padding(.vertical, 5)
            .multilineTextAlignment(.center)
            .font(.headline)
            .background(Color.accentColor.gradient.opacity(isEnabled ? 1 : 0.6), in: .rect(cornerRadius: 12))
            .shadow(color: .accent.opacity(isEnabled ? 0.2 : 0), radius: 10, x: 0, y: -5)
            .foregroundStyle(.white.gradient)
            .buttonBorderShape(.roundedRectangle(radius: 12))
    }
}
