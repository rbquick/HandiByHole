//
//  HoleDetails.swift
//  HandiByHole
//
//  Created by Brian Quick on 2025-10-08.
//

import SwiftUI
enum GolfClub: String, CaseIterable, Identifiable {
    case none = ""
    case driver = "Driver"
    case threeWood = "3-Wood"
    case fiveWood = "5-Wood"
    case resque = "Resque"
    case iron4 = "Iron 4"
    case iron5 = "Iron 5"
    case iron6 = "Iron 6"
    case iron7 = "Iron 7"
    case iron8 = "Iron 8"
    case iron9 = "Iron 9"
    case pWedge = "P Wedge"
    case aWedge = "A Wedge"
    case lob60 = "60 Deg"
    
    var id: String { self.rawValue }
}

struct HoleDetails: View {
    @EnvironmentObject var modelscore: ModelScore
    @EnvironmentObject var modelpar: ModelPar
    @EnvironmentObject var modelcanscore: ModelCanScore
    @Environment(\.dismiss) private var dismiss

    @State var InputClub: GolfClub = .threeWood // this is setup by hole from modelcanscore
    @State var InputDistanceToGreen: Double = 0.0
    @State var unitToGreen: DistanceUnit = .yards
    @State var InputDistandePutt1st: Double = 0.0
    @State var unitputt1st: DistanceUnit = .feet
    @State var InputDistandePutt2nd: Double = 0.0
    @State var unitputt2nd: DistanceUnit = .feet
    @State var InputDistandePutt3rd: Double = 0.0
    @State var unitputt3rd: DistanceUnit = .feet

    @State var InputSandSave: Bool = false
    var body: some View {
        VStack {
            HeaderView()
            Spacer()
            // Unique sorted courses for picker
            let uniqueCourseIDs = Array(Set(modelpar.pars.map { $0.CourseID })).sorted()
                        
            Picker("Course", selection: $modelpar.currentCoureID) {
                ForEach(uniqueCourseIDs, id: \.self) { rec in
                    Text("Course \(rec)").tag(rec)
                            }
                        }

                        // Filter teeIDs for selected course
                    let teeIDs = modelpar.pars
                .filter { $0.CourseID == modelpar.currentCoureID }
                            .map { $0.TeeID }
                        
                        // Unique and sorted teeIDs for selected course
                        let uniqueTeeIDs = Array(Set(teeIDs)).sorted()
                        
            Picker("Tee", selection: $modelpar.currentTeeID) {
                            ForEach(uniqueTeeIDs, id: \.self) { teeID in
                                Text("Tee \(teeID)").tag(teeID)
                            }
                        }
            Text("Yardage \(modelpar.getYardage(hole: modelscore.currentHole))  ")
            Spacer()
            HStack {
                Text("Select a club")
                Spacer()
                Picker("Select a club", selection: $InputClub) {
                    ForEach(GolfClub.allCases) { club in
                        Text(club.rawValue.isEmpty ? "None" : club.rawValue)
                            .tag(club)
                    }
                }
                .frame(width: 130, height: 30)
                .border(.black, width: 1)
            }
            
            Spacer()
            DistanceEntryView(entryName: "to Green", myDistance: $InputDistanceToGreen, selectedUnit: $unitToGreen)
                .frame( height: 30)
            Text("drive \(modelpar.getYardage(hole: modelscore.currentHole) - (Int(InputDistanceToGreen) / 3)) ")
            
            Text("---Putting stats---")
            DistanceEntryView(entryName: "1st",
                              myDistance: $InputDistandePutt1st,
                              selectedUnit: $unitputt1st)
                .frame( height: 30)
            DistanceEntryView(entryName: "2nd", myDistance: $InputDistandePutt2nd, selectedUnit: $unitputt2nd)
                .frame( height: 30)
            DistanceEntryView(entryName: "3rd", myDistance: $InputDistandePutt3rd, selectedUnit: $unitputt3rd)
                .frame( height: 30)
            Toggle("Sand Save", isOn: $InputSandSave)
            
            Spacer()
            Button("Close") {
                dismiss()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .onDisappear {
            print("HoleDetails saved")
            print(InputDistandePutt1st)
            print(InputDistandePutt2nd)
            print(InputDistandePutt3rd)
            modelcanscore.updateHoleDetails(hole: modelscore.currentHole, club: InputClub.rawValue, distance: InputDistanceToGreen, putt1st: InputDistandePutt1st, putt2nd: InputDistandePutt2nd, putt3rd: InputDistandePutt3rd, sandsave: InputSandSave)
        }
        .onAppear {
            // If you want to set based on a String, convert:
            let currentClubString = modelcanscore.canScores[modelscore.currentHole - 1].Club
            if let clubValue = GolfClub(rawValue: currentClubString) {
                InputClub = clubValue
            }
            InputDistanceToGreen = modelcanscore.canScores[modelscore.currentHole - 1].Distance / 3
            InputDistandePutt1st = modelcanscore.canScores[modelscore.currentHole - 1].Putt1st
            unitputt1st = InputDistandePutt1st.truncatingRemainder(dividingBy: 1) == 0 ? .feet : .inches
            InputDistandePutt2nd = modelcanscore.canScores[modelscore.currentHole - 1].Putt2nd
            
            unitputt2nd = InputDistandePutt2nd.truncatingRemainder(dividingBy: 1) == 0 ? .feet : .inches
            InputDistandePutt3rd = modelcanscore.canScores[modelscore.currentHole - 1].Putt3rd
            
            unitputt3rd = InputDistandePutt3rd.truncatingRemainder(dividingBy: 1) == 0 ? .feet : .inches
            InputSandSave = modelcanscore.canScores[modelscore.currentHole - 1].SandSave
            print("HoleDetails appeard")
                            print(InputDistandePutt1st)
                            print(InputDistandePutt2nd)
                            print(InputDistandePutt3rd)
        }
        .padding()
    }
}

#Preview {
    HoleDetails()
        .environmentObject(ModelScore())
        .environmentObject(ModelPar())
        .environmentObject(ModelCanScore())
}
