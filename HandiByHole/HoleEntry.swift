//
//  HoleEntry.swift
//  HandiByHole
//
//  Created by Brian Quick on 2025-04-27.
//

import SwiftUI

struct HoleEntry: View {
    @EnvironmentObject var modelscore: ModelScore
    @EnvironmentObject var modelpar: ModelPar
    @EnvironmentObject var modelcanscore: ModelCanScore
    
    @State private var showingExporter = false
    
    // fields to accept input from views for updating
    @State var InputScore = 0
    @State var InputPutts = 0
    @State var InputBunker = 0
    @State var InputPenalty = 0
    @State var InputFairway = ""
    @State var InputGreen = ""
    @State var InputClub = "3-Wood"
    @State var InputDistance = 0
    @State var InputPutLength = 0
    @State var InputSandSave = false
    @State var InputUPDown = false
    @State var InputMatchscore = 0
    @State var InputMatchUpDown = 0
    
    @State var ShowingScoreCard = false
    
    @FocusState private var isFocused: Bool
    
    let clubPickes = ["", "Driver", "3-Wood", "5-Wood", "Resque", "Iron 4", "Iron 5", "Iron 6", "Iron 7", "Iron 8", "Iron 9", "P Wedge", "A Wedge", "60 Deg"]
    let fairwaySelections = ["", "Left", "Hit", "Right", "Miss", "Bunker"]
    let greenSelections = ["", "Left", "Hit", "Right", "Over", "Short"]
    
    var body: some View {
        VStack {
            VStack {
                HStack {
                    
                    if modelscore.currentHole >= 9 {
                        
                        Text("F:")
                        Text("\(modelscore.scoreFront9)")
                        
                    }
                    if modelscore.currentHole == 18 {
                        
                        Text("B:")
                        Text("\(modelscore.scoreBack9)")
                        
                    }
                    
                    Text("Score:")
                    Text("\(modelscore.scoreCurrent)")
                }
                    HStack {
                    
                    Text("Hole: \(modelscore.currentHole) ")
                    Text("Par: \(modelpar.getPar(hole: modelscore.currentHole)) ")
                    }
                
            }
            .frame(maxWidth: .infinity, minHeight: 120)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .font(.largeTitle)
            /*
             HStack {
             Text("Club")
             Spacer()
             Picker("Club", selection: $InputClub) {
             ForEach(clubPickes, id: \.self) {
             Text($0)
             }
             }
             .frame(width: 130, height: 30)
             .border(.black, width: 1)
             }
             HStack {
             Text("Distance: \(modelpar.getYardage(hole: modelscore.currentHole))")
             Spacer()
             
             HStack {
             TextField("Enter number", value: $InputDistance, formatter: NumberFormatter())
             .textFieldStyle(RoundedBorderTextFieldStyle())
             .keyboardType(.numberPad)
             .focused($isFocused)
             .padding()
             Text("Yards")
             }
             .frame(width: 130, height: 30)
             .border(.black, width: 1)
             }
             .onTapGesture {
             isFocused = false // Dismiss keyboard
             }
             .toolbar {
             ToolbarItemGroup(placement: .keyboard) {
             Spacer()
             Button("Done") {
             isFocused = false
             }
             }
             }
             */
            Spacer()
            HStack {
                Text("Strokes: ")
                Spacer()
                ButtonCounter(count: $InputScore)
                    .onChange(of: InputScore) { _ in
                                            update()
                                            calcUpDown()
                                        }
            }
            HStack {
                Text("Putts: ")
                Spacer()
                ButtonCounter(count: $InputPutts)
            }
            /*
             HStack {
             Text("Put Length:")
             Spacer()
             
             HStack {
             TextField("Enter number", value: $InputPutLength, formatter: NumberFormatter())
             .textFieldStyle(RoundedBorderTextFieldStyle())
             .keyboardType(.numberPad)
             .focused($isFocused)
             .padding()
             Text("Feet")
             }
             .frame(width: 130, height: 30)
             .border(.black, width: 1)
             }
             */
            if modelpar.getPar(hole: modelscore.currentHole) != 3 {
                AcurracySelector(accuracy: $InputFairway, section: "Fairways", selections: fairwaySelections)
            }
            AcurracySelector(accuracy: $InputGreen, section: "Greens", selections: greenSelections)
            HStack {
                Text("Bunkers: ")
                Spacer()
                ButtonCounter(count: $InputBunker)
            }
            HStack {
                Text("Penalties: ")
                Spacer()
                ButtonCounter(count: $InputPenalty)
            }
            
            HStack {
                Button("Show Match") {
                    modelcanscore.showMatch.toggle()
                }
                Spacer()
            }
            if modelcanscore.showMatch {
                
                HStack {
                    Text("Match Score: ")
                    Spacer()
                    ButtonCounter(count: $InputMatchscore)
                        .onChange(of: InputMatchscore) { _ in
                            update()
                            calcUpDown()
                        }
                }
                HStack {
                    Text("Front: \(modelcanscore.matchFront)    Back: \(modelcanscore.matchBack)    Total: \(modelcanscore.match18)")
                    Spacer()
                    if modelscore.currentHole == 18 {
                        Text("$$$: \(modelcanscore.dollars)")
                            .background(modelcanscore.dollars < 0 ? Color.red : Color.white)
                    }
                }
            }
            /*
             HStack {
             Text("Sand Save: ")
             Spacer()
             YNSelector(YN: $InputSandSave)
             }
             HStack {
             Text("Up & Down: ")
             Spacer()
             YNSelector(YN: $InputUPDown)
             }
             */
            Spacer()
            HStack {
                if modelscore.currentHole == 1 {
                    Button("New Round") {
                        newRound()
                        fillInputs()
                    }
                    .frame(maxWidth: .infinity, minHeight: 44)
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                Button("Card") {
                    update()
                    ShowingScoreCard = true
                }
                .frame(maxWidth: .infinity, minHeight: 44)
                .background(Color.red)
                .foregroundColor(.white)
                .cornerRadius(10)
                .sheet(isPresented: $ShowingScoreCard) {
                    ScoreCardView() // Replace with your actual view
                }
                
                if modelscore.currentHole > 1 {
                    Button("Previous Hole") {
                        update()
                        modelscore.currentHole -= 1
                        modelcanscore.currentHole -= 1
                        fillInputs()
                    }
                    .frame(maxWidth: .infinity, minHeight: 44)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                if modelscore.currentHole < 18 {
                    
                    Button("Next Hole") {
                        update()
                        modelscore.currentHole += 1
                        modelcanscore.currentHole += 1
                        fillInputs()
                    }
                    .frame(maxWidth: .infinity, minHeight: 44)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                if modelscore.currentHole == 18 {
                    Button("Export") {
                        saveJASON()
                    }
                }
            }
            .frame(maxWidth: .infinity, minHeight: 30)
        }
        .padding()
        .onAppear {
            fillInputs()
        }
    }
}

#Preview {
    HoleEntry()
        .environmentObject(ModelScore())
        .environmentObject(ModelCanScore())
        .environmentObject(ModelPar())
}
extension HoleEntry {
    func calcUpDown()  {
        modelcanscore.match18 = 0
        modelcanscore.matchFront = 0
        modelcanscore.matchBack = 0
        var totalUp = 0
        for hole in 1...modelscore.currentHole {
            totalUp = modelscore.scores[hole-1].Score < modelcanscore.canScores[hole-1].MatchScore ? 1 : modelscore.scores[hole-1].Score > modelcanscore.canScores[hole-1].MatchScore ? -1 : 0
            if hole < 10 {
                modelcanscore.matchFront += totalUp
            } else {
                modelcanscore.matchBack += totalUp
            }
            modelcanscore.match18 = modelcanscore.matchFront + modelcanscore.matchBack
            if modelscore.currentHole == 18 {
                modelcanscore.dollars = modelcanscore.matchFront < 0 ? -1 : modelcanscore.matchFront > 0 ? 1 : 0
                modelcanscore.dollars += modelcanscore.matchBack < 0 ? -1 : modelcanscore.matchBack > 0 ? 1 : 0
                let totmatch =  modelcanscore.matchFront + modelcanscore.matchBack
                modelcanscore.dollars += totmatch < 0 ? -1 : totmatch > 0 ? 1 : 0
                if modelcanscore.canScores[16].MatchScore != 0 {
                    modelcanscore.dollars += totalUp
                }
            } else {
                modelcanscore.dollars = 0
            }
        }
    }
    func exportButtonPressed() {
            update()
            showingExporter.toggle()
        }
    func fileURL() -> URL? {
        let fileManager = FileManager.default
        do {
            let path = try fileManager.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
            let myURL = path.appendingPathComponent(modelscore.JSONFilename)
            return myURL
        } catch {
            print("error creating file")
            return nil
        }
    }
    func newRound() {
        modelscore.scores.removeAll()
        modelcanscore.canScores.removeAll()
        for i in 1...18 {
            let rec = CKScoreRec(PlayerID: 32, GameID: 1, Hole: i, Score: modelpar.getPar(hole: i), Fairway: "H", Green: "H", Putts: 2, Bunker: 0, Penalty: 0)
            modelscore.scores.append(rec!)
            let rec1 = CKCanScoreRec(Hole: i, Club: modelpar.getPar(hole: i) == 3 ? clubPickes[8] : clubPickes[2], Distance: modelpar.getInputDistance(hole: i), PutLength: 0, SandSave: false, UPDown: false, MatchScore: modelpar.getPar(hole: i), MatchUpDown: 0)
            modelcanscore.canScores.append(rec1!)
        }
        fillInputs()
    }
    func fillInputs() {
        InputScore = modelscore.scores[modelscore.currentHole - 1].Score
        InputPutts = modelscore.scores[modelscore.currentHole - 1].Putts
        InputBunker = modelscore.scores[modelscore.currentHole - 1].Bunker
        InputPenalty = modelscore.scores[modelscore.currentHole - 1].Penalty
        InputFairway = modelscore.scores[modelscore.currentHole - 1].Fairway
        InputGreen = modelscore.scores[modelscore.currentHole - 1].Green
        InputClub = modelcanscore.canScores[modelscore.currentHole - 1].Club
        InputDistance = modelcanscore.canScores[modelscore.currentHole - 1].Distance
        InputPutLength = modelcanscore.canScores[modelscore.currentHole - 1].PutLength
        InputSandSave = modelcanscore.canScores[modelscore.currentHole - 1].SandSave
        InputUPDown = modelcanscore.canScores[modelscore.currentHole - 1].UPDown
        InputMatchscore = modelcanscore.canScores[modelscore.currentHole - 1].MatchScore
        InputMatchUpDown = modelcanscore.canScores[modelscore.currentHole - 1].MatchUpDown
        calcUpDown()
    }
    func saveJASON() {
        do {
            try saveJASONToiCloud(items: modelscore.scores, filename: modelscore.JSONFilename)
        } catch {
            print("error Saving Scores \(error)")
        }
        do {
            try saveJASONToiCloud(items: modelcanscore.canScores, filename: modelcanscore.JSONFilename)
        } catch {
            print("error Saving Scores \(error)")
        }
    }
    func update() {
        let rec = CKScoreRec(PlayerID: 32, GameID: 1, Hole: modelscore.currentHole, Score: InputScore, Fairway: InputFairway, Green: InputGreen, Putts: InputPutts, Bunker: InputBunker, Penalty: InputPenalty)
        modelscore.scores[modelscore.currentHole - 1] = rec!
        do {
            try saveToJSONFile(items: modelscore.scores, filename: modelscore.JSONFilename)
        } catch {
            print("error saving scores data to json file \(error)")
        }
        let rec1 = CKCanScoreRec(Hole: modelscore.currentHole, Club: InputClub, Distance: InputDistance, PutLength: InputPutLength, SandSave: InputSandSave, UPDown: InputUPDown, MatchScore: InputMatchscore, MatchUpDown: InputMatchUpDown)
        modelcanscore.canScores[modelscore.currentHole - 1] = rec1!
        do {
            try saveToJSONFile(items: modelcanscore.canScores, filename: modelcanscore.JSONFilename)
        } catch {
            print("error saving canscores data to json file \(error)")
        }
    }
}
