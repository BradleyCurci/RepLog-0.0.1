//
//  BGLinearGradient.swift
//  RepLog
//
//  Created by Brad Curci on 1/13/25.
//

import SwiftUI

struct BGLinearGradient: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(
                LinearGradient(colors: [.BG, .gradient], startPoint: .topLeading, endPoint: .bottomTrailing)
            )
    }
}

extension View {
    func bgLinearGradient() -> some View {
        self.modifier(BGLinearGradient())
    }
}

