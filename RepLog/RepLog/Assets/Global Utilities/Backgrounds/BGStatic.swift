//
//  BGStatic.swift
//  RepLog
//
//  Created by Brad Curci on 1/13/25.
//

import SwiftUI

struct BGStatic: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(.BG)
            .edgesIgnoringSafeArea(.all)
    }
}

extension View {
    func bgStatic() -> some View {
        self.modifier(BGStatic())
    }
}
