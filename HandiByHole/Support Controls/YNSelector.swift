//
//  YNSelector.swift
//  HandiByHole
//
//  Created by Brian Quick on 2025-05-06.
//

import SwiftUI

struct YNSelector: View {
    @Binding var YN: Bool
    var body: some View {
        HStack() {
            Button(action: {
                YN = true
            }) {
                Image(systemName: "y.circle")
                    .font(.largeTitle)
            }.background(YN ? Color.gray.opacity(0.3) : Color.clear)
                .clipShape(Circle())
            
            
            Button(action: {
                YN = false
            }) {
                Image(systemName: "n.circle")
                    .font(.largeTitle)
            }.background(!YN ? Color.gray.opacity(0.3) : Color.clear)
                .clipShape(Circle())
        }
        .border(.black, width: 1)
        .frame(width: 100, height: 50)
//        .padding(.trailing)
    }
    }
#Preview {
    YNSelector(YN: .constant(false))
}
