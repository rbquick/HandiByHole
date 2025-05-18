//
//  ParRowView.swift
//  HandiByHole
//
//  Created by Brian Quick on 2025-05-12.
//

import SwiftUI

struct ParRowView: View {
    let title: String
    let numbers: [Int]
    let rating: [String]
    var trailingLabels: [Int]
    
    @State private var myScore: Int = 0

    var body: some View {
        GeometryReader { geometry in
            let totalWidth = geometry.size.width - 32
            let cellCount = numbers.count + trailingLabels.count + 1 // +1 for the doubled leading
            if totalWidth > 0 && cellCount > 0 {
                let baseWidth = totalWidth / CGFloat(cellCount + 1)
                
                HStack(spacing: 0) {
                    Text(title)
                        .frame(width: baseWidth * 1.5)
                    
                    ForEach(numbers.indices, id: \.self) { ind in
                        let num = numbers[ind]
                        if title == "Par" {
                            Text("\(num)")
                                .frame(width: baseWidth, height: 44)
                        } else {
                            
                            
                            if num == 0 {
                                Text(" ")
                                    .frame(width: baseWidth)
                            } else {
                                
                                switch rating[ind] {
                                    case "BI":
                                        // birdie
                                        Text("\(num)")
                                            .frame(width: baseWidth, height: 44)
                                            .overlay(
                                                Circle()
                                                    .stroke(Color.primary, lineWidth: 2)
                                            )
                                    case "BO":
                                        // bogie
                                        Text("\(num)")
                                            .frame(width: baseWidth, height: 44)
                                            .overlay(
                                                Rectangle()
                                                    .stroke(Color.primary, lineWidth: 1)
                                            )
                                    case "DO":
                                        // worse
                                        Text("\(num)")
                                            .frame(width: baseWidth, height: 44)
                                            .overlay(
                                                Rectangle()
                                                    .stroke(Color.primary, lineWidth: 1)
                                            )
                                            .overlay(
                                                Rectangle()
                                                    .inset(by: 4)
                                                    .stroke(Color.primary, lineWidth: 1)
                                            )
                                    default:
                                        Text("\(num)")
                                            .frame(width: baseWidth, height: 44)
                                }
                                
                                
                                
                                
                            }
                        }
                    }
                    
                    ForEach(trailingLabels, id: \.self) { label in
                        Text("\(label)")
                            .frame(width: baseWidth * 1.5)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                .padding(8)
                //            .background(Color.blue)
                //            .foregroundColor(.white)
                //                .cornerRadius(8)
            }
        }
        .frame(height: 5)
        .padding(.horizontal, 8)
    }
}
#Preview {
    ParRowView(title: "Hole", numbers: Array(10...18), rating: ["P", "P", "P", "P", "P", "P", "P", "P", "P"], trailingLabels: [35, 770])
}
//extension ParRowView {
//    func accumScore(score: Int) {
//        myScore += score
//        trailingLabels[0] = "\(myScore)"
//    }
//}
