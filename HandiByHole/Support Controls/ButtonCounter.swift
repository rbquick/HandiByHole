//
//  ButtonCounter.swift
//  HandiByHole
//
//  Created by Brian Quick on 2025-04-27.
//

import SwiftUI

struct ButtonCounter: View {
    @Binding var count: Int
    @State  var maxCount: Int = 9
    var body: some View {
        HStack() {
            Button(action: {
                if count > 0 { count -= 1 }
            }) {
                Image(systemName: "minus.circle")
                    .font(.largeTitle)
            }
            
            Text("\(count)")
                .font(.largeTitle)
                .frame(minWidth: 50)
            
            Button(action: {
                if count < maxCount { count += 1 }
            }) {
                Image(systemName: "plus.circle")
                    .font(.largeTitle)
            }
        }
        .border(.black, width: 1)
        .frame(width: 100, height: 50)
        
        .padding(.trailing, 20)
    }
}

#Preview {
    ButtonCounter(count: .init(get: { 4 }, set: { _ in }))
}
