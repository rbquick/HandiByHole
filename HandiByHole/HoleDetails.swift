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
    @EnvironmentObject var modelcandistance: ModelCanDistance
    @Environment(\.dismiss) private var dismiss

    @State var InputClub: GolfClub = .threeWood
    @State var InputDistanceToGreen: Double = 0.0
    @State var distanceText: String = ""
    @State var filteredDistanceRecords: [CKCanDistance] = []

    var body: some View {
        VStack {
            HeaderView()

            let uniqueCourseIDs = Array(Set(modelpar.pars.map { $0.CourseID })).sorted()
            let teeIDs = modelpar.pars
                .filter { $0.CourseID == modelpar.currentCoureID }
                .map { $0.TeeID }
            let uniqueTeeIDs = Array(Set(teeIDs)).sorted()

            HStack {
                Text("Course")
                Picker("Course", selection: $modelpar.currentCoureID) {
                    ForEach(uniqueCourseIDs, id: \.self) { rec in
                        Text("\(rec)").tag(rec)
                    }
                }
                .frame(maxWidth: 80)

                Text("Tee")
                Picker("Tee", selection: $modelpar.currentTeeID) {
                    ForEach(uniqueTeeIDs, id: \.self) { teeID in
                        Text("\(teeID)").tag(teeID)
                    }
                }
                .frame(maxWidth: 80)

                Spacer()
                Text("Yds \(modelpar.getYardage(hole: modelscore.currentHole))")
            }

            HStack {
                Text("Club")
                Picker("Club", selection: Binding(
                    get: { InputClub },
                    set: { newClub in
                        InputClub = newClub
                        filteredDistanceRecords = modelcandistance.records(for: newClub.rawValue)
                    }
                )) {
                    ForEach(GolfClub.allCases) { club in
                        Text(clubPickerLabel(for: club))
                            .tag(club)
                    }
                }
                .frame(width: 220)
                .border(.black, width: 1)
                
                Text("Yds")
                TextField("0", text: Binding(
                    get: { distanceText },
                    set: { newValue in
                        setDistanceText(newValue)
                    }
                ))
                .keyboardType(.numberPad)
                .textFieldStyle(.roundedBorder)
            }
            .frame(height: 36)

            List {
                ForEach(filteredDistanceRecords) { record in
                    HStack {
                        Text(record.entryDate.formatted(date: .numeric, time: .standard))
                        Spacer()
                        Text("Hole \(record.Hole)")
                        Spacer()
                        Text(record.Distance, format: .number.precision(.fractionLength(0)))
                        Text("yds")
                    }
                }
                .onDelete(perform: deleteDistanceRecords)
            }

            HStack {
                Button("Cancel") {
                    dismiss()
                }
                .padding()
                .background(Color.gray)
                .foregroundStyle(.white)
                .clipShape(.rect(cornerRadius: 8))

                Spacer()

                Button("Save") {
                    saveDistanceRecord()
                    dismiss()
                }
                .padding()
                .background(Color.blue)
                .foregroundStyle(.white)
                .clipShape(.rect(cornerRadius: 8))
            }
        }
        .onAppear {
            loadInitialRecord()
            print("HoleDetails appeard")
        }
        .padding()
    }

    func loadInitialRecord() {
        if let initialRecord = modelcandistance.newestRecord(for: modelscore.currentHole) ?? modelcandistance.newestRecord() {
            InputDistanceToGreen = initialRecord.Distance
            distanceText = initialRecord.Distance.formatted(.number.precision(.fractionLength(0)))
            if let clubValue = GolfClub(rawValue: initialRecord.Club) {
                InputClub = clubValue
            }
            filteredDistanceRecords = modelcandistance.records(for: InputClub.rawValue)
        } else {
            setDistanceText("")
            filteredDistanceRecords = modelcandistance.records(for: InputClub.rawValue)
        }
    }

    func clubPickerLabel(for club: GolfClub) -> String {
        let clubName = club.rawValue.isEmpty ? "None" : club.rawValue
        guard let averageDistance = modelcandistance.averageDistance(for: club.rawValue) else {
            return clubName
        }
        let averageText = averageDistance.formatted(.number.precision(.fractionLength(0)))
        return "\(clubName) - Avg \(averageText) yds"
    }

    func setDistanceText(_ newValue: String) {
        let numericValue = newValue.filter { $0.isNumber }
        distanceText = numericValue
        InputDistanceToGreen = Double(numericValue) ?? 0
    }

    func saveDistanceRecord() {
        print("HoleDetails saved")
        modelcandistance.addHoleDetails(hole: modelscore.currentHole, club: InputClub.rawValue, distance: InputDistanceToGreen)
        modelcandistance.save()
    }

    func deleteDistanceRecords(at offsets: IndexSet) {
        let recordsToDelete = offsets.map { filteredDistanceRecords[$0] }
        modelcandistance.delete(records: recordsToDelete)
        modelcandistance.save()
        filteredDistanceRecords = modelcandistance.records(for: InputClub.rawValue)
    }
}

#Preview {
    HoleDetails()
        .environmentObject(ModelScore())
        .environmentObject(ModelPar())
        .environmentObject(ModelCanScore())
        .environmentObject(ModelCanDistance())
}
