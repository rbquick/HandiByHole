//
//  DistanceEntryView.swift
//  HandiByHole
//
//  Created by Brian Quick on 2025-10-09.
//

import SwiftUI

enum DistanceUnit: String, CaseIterable, Identifiable {
    case yards = "Yds"
    case feet = "Ft"
    case inches = "In"
    var id: String { self.rawValue }
}

struct DistanceEntryView: View {
    var entryName  = "enter"
    @Binding var myDistance: Double
    @Binding var selectedUnit: DistanceUnit

    @State var input: String = ""

    var body: some View {
        HStack {
            Text(entryName)
            ForEach(DistanceUnit.allCases) { unit in
                Button(action: {
                    selectedUnit = unit
                    refreshInput()
                }) {
                    HStack {
                        Image(systemName: selectedUnit == unit ? "largecircle.fill.circle" : "circle")
                            .foregroundStyle(selectedUnit == unit ? .blue : .gray)
                        Text(unit.rawValue)
                            .foregroundStyle(.primary)
                    }
                }
                .buttonStyle(.plain)
            }
            myTextField(value: Binding(
                get: { input },
                set: { newValue in
                    input = newValue
                    updateDistance(from: newValue)
                }
            ), title: "", texttype: .Int)
            .padding(.horizontal)
            .background(Color(.systemGray6))
            .clipShape(.rect(cornerRadius: 8))
        }
        .onAppear {
            refreshInput()
        }
    }

    func refreshInput() {
        let value = switch selectedUnit {
        case .yards:
            myDistance / 3
        case .feet:
            myDistance
        case .inches:
            myDistance * 12
        @unknown default:
            myDistance
        }
        input = value.formatted(.number.precision(.fractionLength(0)))
    }

    func updateDistance(from newValue: String) {
        switch selectedUnit {
        case .yards:
            myDistance = (Double(newValue) ?? 0) * 3
        case .feet:
            myDistance = (Double(newValue) ?? 0)
        case .inches:
            myDistance = (Double(newValue) ?? 0) / 12
        @unknown default:
            break
        }
    }
}


#Preview {
    DistanceEntryView(myDistance: .constant(0.0), selectedUnit: .constant(DistanceUnit.yards))
}

