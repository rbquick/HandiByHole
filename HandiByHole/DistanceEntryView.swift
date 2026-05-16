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
//    @State private var value: Double = 0
    
    @State var input: String = ""

    var body: some View {
            HStack {
                Text(entryName)
                    ForEach(DistanceUnit.allCases) { unit in
                        Button(action: {
                            selectedUnit = unit
                        }) {
                            HStack {
                                Image(systemName: selectedUnit == unit ? "largecircle.fill.circle" : "circle")
                                    .foregroundColor(selectedUnit == unit ? .blue : .gray)
                                Text(unit.rawValue)
                                    .foregroundColor(.primary)
                            }
//                            .padding(.horizontal)
                        }
                        .buttonStyle(.plain)
                    }
                myTextField(value: $input, title: "", texttype: .Int)
                    .padding(.horizontal)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .onChange(of: input) { newvalue in
                        switch selectedUnit {
                            case .yards:
                                myDistance = (Double(newvalue) ?? 0) * 3
                            case .feet:
                                myDistance = (Double(newvalue) ?? 0)
                            case .inches:
                                myDistance = (Double(newvalue) ?? 0) / 12
                            @unknown default:
                                break
                        }
                    }
            }
            .onAppear {
                switch selectedUnit {
                                            case .yards:
                        input = String(format: "%.0f", myDistance)
                                            case .feet:
                                                
                        input = String(format: "%.0f", myDistance)
                                            case .inches:
                                                
                        input = String(format: "%.0f", myDistance * 12)
                                            @unknown default:
                                                break
                                        }
            }
    }
}


#Preview {
    DistanceEntryView(myDistance: .constant(0.0), selectedUnit: .constant(DistanceUnit.yards))
}

