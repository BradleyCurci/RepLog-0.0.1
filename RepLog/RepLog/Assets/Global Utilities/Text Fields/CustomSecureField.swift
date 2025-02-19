//
//  CustomSecureField.swift
//  RepLog
//
//  Created by Brad Curci on 1/13/25.
//

import SwiftUI

struct CustomSecureField: View {
    var label: String
    @Binding var text: String
    @FocusState private var isFocused: Bool
    @State private var isSecure: Bool = true
    
    var body: some View {
        ZStack(alignment: .leading) {
            Text(label)
                .foregroundStyle(isFocused ? .accent : .gray)
                .padding(.horizontal, 4)
                .scaleEffect(isFocused || !text.isEmpty ? 0.8 : 1.0, anchor: .leading)
                .offset(y: isFocused || !text.isEmpty ? -25 : 0)
                .animation(.easeInOut(duration: 0.2), value: isFocused || !text.isEmpty)
            
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    if isSecure {
                        SecureField("", text: $text)
                            .focused($isFocused)
                            .padding(.top, 8)
                            .padding(.bottom, 2)
                    } else {
                        TextField("", text: $text)
                            .focused($isFocused)
                            .padding(.top, 8)
                            .padding(.bottom, 2)
                    }
                    
                    Button(action: {
                        isSecure.toggle()
                    }) {
                        Image(systemName: isSecure ? "eye.slash" : "eye")
                            .foregroundColor(.gray)
                    }
                    .padding(.trailing, 8)
                }
                
                Rectangle()
                    .frame(height: 1.5)
                    .foregroundStyle(isFocused ? .accent : .gray)
            }
        }
        .font(.custom("montserrat", size: 16))
    }
}

