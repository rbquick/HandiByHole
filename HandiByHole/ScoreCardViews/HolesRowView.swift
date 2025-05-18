//
//  HolesRowView.swift
//  HandiByHole
//
//  Created by Brian Quick on 2025-05-12.
//

import SwiftUI

struct HoleRowView: View {
    let title: String
    let numbers: [Int]
    let trailingLabels: [String]
    let myColor: Color

    var body: some View {
        GeometryReader { geometry in
            let totalWidth = geometry.size.width - 32
            let cellCount = numbers.count + trailingLabels.count + 1 // +1 for the doubled leading
            if totalWidth > 0 && cellCount > 0 {
                let baseWidth = totalWidth / CGFloat(cellCount + 1)
                
                HStack(spacing: 0) {
                    Text(title)
                        .frame(width: baseWidth * 1.5)
                    
                    ForEach(numbers, id: \.self) { num in
                        Text("\(num)")
                            .frame(width: baseWidth)
                    }
                    
                    ForEach(trailingLabels, id: \.self) { label in
                        Text(label)
                            .frame(width: baseWidth * 1.5)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                .padding(8)
                .background(myColor)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
        }
        .frame(height: 5)
        .padding(.horizontal, 8)
    }
}
#Preview {
    HoleRowView(title: "Hole", numbers: Array(10...18), trailingLabels: ["IN", "TOT"], myColor: Color.blue)
}
