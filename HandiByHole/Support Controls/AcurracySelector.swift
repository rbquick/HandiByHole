//
//  AcurracySelector.swift
//  HandiByHole
//
//  Created by Brian Quick on 2025-04-27.
//

import SwiftUI

struct AcurracySelector: View {
    @Binding var accuracy: String
    @State var section: String = "Fairways"
    @State var selections: [String] = ["Hit", "Right", "Left", "Miss", "Bunker"]

    @State private var showBubble: Bool = false
    @State private var bubbleText: String = ""
    @State private var bubblePosition: CGPoint = .zero

    var body: some View {
        VStack(alignment: .leading) {

            HStack(spacing: 12) {
                Text(section)
                    .font(.headline)
                ForEach(selections, id: \.self) { selection in
                    if !selection.isEmpty {
                        let prefix = String(selection.prefix(1))
                        Button {
                            accuracy = prefix
                        } label: {
                            Text(prefix)
                                .font(.headline)
                                .foregroundColor(.primary)
                                .frame(width: 44, height: 44)
                                .background(
                                    Circle()
                                        .fill(accuracy == prefix ? Color.gray : Color.clear)
                                )
                                .overlay(
                                    Circle()
                                        .stroke(Color.primary, lineWidth: 2)
                                )
                        }
                        .simultaneousGesture(
                            LongPressGesture(minimumDuration: 0.5)
                                .onEnded { _ in
                                    bubbleText = selection
                                    showBubble = true
                                }
                        )
                    }
                }
            }
//            .padding(.top, 8)
        }
//        .padding()
        .overlay(
            Group {
                if showBubble {
                    Text(bubbleText)
                        .font(.caption)
                        .padding(8)
                        .background(Color.black.opacity(0.7))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .transition(.scale)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                withAnimation {
                                    showBubble = false
                                }
                            }
                        }
                        .offset(y: -80) // move the bubble above
                }
            }
        )
    }
}

#Preview {
    AcurracySelector(accuracy: .constant(""))
}

