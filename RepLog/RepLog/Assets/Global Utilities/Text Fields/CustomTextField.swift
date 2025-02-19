//
//  CustomTextField.swift
//  RepLog
//
//  Created by Brad Curci on 1/13/25.
//

import SwiftUI

struct CustomTextField: TextFieldStyle {
    
    var label: String
    
    @Binding var text: String
    
    @FocusState private var isFocused: Bool
    
    func _body(configuration: TextField<_Label>) -> some View {
        ZStack(alignment: .leading) {
            Text(label)
                .foregroundStyle(isFocused ? .accent : .gray)
                .padding(.horizontal, 4)
                .scaleEffect(isFocused || !text.isEmpty ? 0.8 : 1.0, anchor: .leading)
                .offset(y: isFocused || !text.isEmpty ? -25 : 0)
                .animation(.easeInOut(duration: 0.2), value: isFocused || !text.isEmpty)
            
            VStack(alignment: .leading, spacing: 4) {
                configuration
                    .padding(.top, 8)
                    .padding(.bottom, 2)
                    .focused($isFocused)
                        
                Rectangle()
                    .frame(height: 1.5)
                    .foregroundColor(isFocused ? .accent : .gray)
            }
        }
        .font(.custom("montserrat", size: 16))
    }
}
