//
//  BackgroundOverlay.swift
//  Taskeando
//
//  Created by Carlos Xavier Carvajal Villegas on 24/5/25.
//

import SwiftUI

struct BackgroundOverlay: ViewModifier {
    @Environment(\.accessibilityReduceTransparency) var reduceTransparency: Bool
    let showOverlay: Bool
    
    func body(content: Content) -> some View {
        content
            .overlay {
                if !reduceTransparency {
                    Rectangle()
                        .fill(.ultraThinMaterial)
                        .ignoresSafeArea()
                        .opacity(showOverlay ? 0 : 1)
                } else {
                    Rectangle()
                        .fill(Color.black.opacity(0.5))
                        .ignoresSafeArea()
                        .opacity(showOverlay ? 0 : 1)
                }
            }
    }
}

extension View {
    func backgroundOverlay(_ showOverlay: Bool) -> some View {
        modifier(BackgroundOverlay(showOverlay: showOverlay))
    }
}
