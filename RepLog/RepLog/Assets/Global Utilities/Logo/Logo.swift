//
//  Logo.swift
//  RepLog
//
//  Created by Brad Curci on 1/13/25.
//

import SwiftUI

struct Logo: View {
    var body: some View {
        HStack(spacing: 0) {
            Text("Rep")
                .foregroundStyle(.accent)
            Text("Log")
        }
        .font(.custom("montserrat", size: 40))
    }
}

#Preview {
    Logo()
}
