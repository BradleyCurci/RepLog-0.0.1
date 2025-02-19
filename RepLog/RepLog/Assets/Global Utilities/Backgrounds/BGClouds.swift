//
//  BGClouds.swift
//  RepLog
//
//  Created by Brad Curci on 1/13/25.
//

import SwiftUI

struct BGClouds: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(
                ZStack {
                    Color.BG
                        .ignoresSafeArea()
                    
                    GeometryReader { geo in
                        ZStack(alignment: .top) {
                            HStack {
                                Corner_Element(color: .gradient)
                                    .offset(x: -geo.size.width * 0.1, y: -geo.size.height * 0.1)
                                
                                Spacer()
                            }
                            
                            HStack {
                                Spacer()
                                Corner_Element(color: .accent1.opacity(0.6))
                                    .offset(x: geo.size.width * 0.1, y: -geo.size.height * 0.1)
                            }
                        }
                    }
                }
            )
    }
}

extension View {
    func bgClouds() -> some View {
        self.modifier(BGClouds())
    }
}

struct Corner_Element: View {
    var color: Color
    var body: some View {
        Ellipse()
            .fill(color)
            .frame(width: 250, height: 125)
            .blur(radius: 50)
    }
}
