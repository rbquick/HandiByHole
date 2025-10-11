//
//  HoleDetails.swift
//  HandiByHole
//
//  Created by Brian Quick on 2025-10-08.
//

import SwiftUI

struct HoleDetails: View {
    @EnvironmentObject var modelscore: ModelScore
    @EnvironmentObject var modelpar: ModelPar
    @EnvironmentObject var modelcanscore: ModelCanScore
    @Environment(\.dismiss) private var dismiss
    
    
    @State var InputClub = "3-Wood" // this is setup by hole from modelcanscore
    let clubPickes = ["", "Driver", "3-Wood", "5-Wood", "Resque", "Iron 4", "Iron 5", "Iron 6", "Iron 7", "Iron 8", "Iron 9", "P Wedge", "A Wedge", "60 Deg"]
    @State var InputDistanceToGreen: Double = 0.0
    var body: some View {
        VStack {
            HeaderView()
            Spacer()
            HStack {
                Text("Select a club")
                Spacer()
                Picker("Select a club", selection: $InputClub) {
                    ForEach(clubPickes, id: \.self) {
                        Text($0)
                    }
                }
                .frame(width: 130, height: 30)
                .border(.black, width: 1)
            }
            .onAppear {
                InputClub = modelcanscore.canScores[modelscore.currentHole - 1].Club
            }
            Spacer()
            DistanceEntryView(entryName: "to Green", myDistance: $InputDistanceToGreen, selectedUnit: .yards)
                .frame( height: 30)
            Text("in feet \(InputDistanceToGreen)")
            Text("drive \(modelpar.getYardage(hole: modelscore.currentHole) - (Int(InputDistanceToGreen) / 3)) ")
            Text("Display distance of drive")
            Text("---Putting stats---")
            Text("show total putts...total dispance")
            Text("1st Putt distance")
            Text("2nd Putt distance")
            Text("2rd Putt distance")
            
            
            
            Spacer()
            Button("Close") {
                dismiss()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .padding()
    }
}

#Preview {
    HoleDetails()
        .environmentObject(ModelScore())
        .environmentObject(ModelPar())
}
