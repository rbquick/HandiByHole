//
//  ModelScore.swift
//  icloudIOS
//
//  Created by Brian Quick on 2021-09-09.
//

import SwiftUI
import CloudKit
import Combine

class ModelScore: ObservableObject {
    @Published var scores = [CKScoreRec]()
    @Published var isChanged = 0
    @Published var girs = [Int]()
    @Published var currentHole: Int = 1

    let JSONFilename = "scores.json"
    let msgChanged = "Records Changed"
    var addRequired = false
    var results = ""
    var cancellables = Set<AnyCancellable>()
    


    var isTracing: Bool = false
    func tracing(function: String) {
        if isTracing {
            print("ModelScore \(function) ")
            myLogger.log("ModelScore \(function)")
        }
    }

    init() {
        tracing(function: "init")
        read()
        if scores.count == 0 {
            previewData()
        }
        setInput(hole: 1)
    }

    @MainActor static let currentModel = ModelScore()

    func setInput(hole: Int) {

    }
    func previewData() {
        scores.removeAll()
        for i in 1...18 {
            let myRec = CKScoreRec(PlayerID: 32, GameID: 1, Hole: i, Score: 4, Fairway: "H", Green: "O", Putts: 2, Bunker: 0, Penalty: 0)!
            scores.append(myRec)
        }
        initializeGirs()
    }
    func initializeGirs() {
        girs.removeAll()
        for _ in 0..<18 {
            girs.append(0)
        }
    }
    func read() {
        do {
            try readFromJSONFile(filename: JSONFilename, model: &scores)
            print("Scores Read Maybe")
        } catch {
            previewData()
            print("error Reading Scores \(error)")
        }
    }
    func save() {

        do {
//
            try saveToJSONFile(items: scores, filename: JSONFilename)
        } catch {
            print("error Saving Scores \(error)")
        }
        
    }
    var bunkerFront9:  Int { return scores.filter({ $0.Hole < 10 }).map({ $0.Bunker }).reduce(0, +) }
    var bunkerBack9:  Int { return scores.filter({ $0.Hole > 9 }).map({ $0.Bunker }).reduce(0, +) }
    var bunkerBack18:  Int { return scores.reduce(0, {$0 + $1.Bunker}) }

    var fairwayRecorded: Int { return scores.filter({ !$0.Fairway.isEmpty }).map({ _ in 1 }).reduce(0, +) }
    var fairwayFront9:  Int { return scores.filter({ $0.Fairway == "H" && $0.Hole < 10}).map({ _ in 1 }).reduce(0, +) }
    var fairwayBack9:  Int { return scores.filter({ $0.Fairway == "H" && $0.Hole > 9 }).map({ _ in 1 }).reduce(0, +) }
    var fairwayBack18:  Int { return scores.filter({ $0.Fairway == "H" }).map({ _ in 1 }).reduce(0, +) }
    var fairwayH:  Int { return scores.filter({ $0.Fairway == "H" }).map({ _ in 1 }).reduce(0, +) }
    var fairwayR:  Int { return scores.filter({ $0.Fairway == "R" }).map({ _ in 1 }).reduce(0, +) }
    var fairwayL:  Int { return scores.filter({ $0.Fairway == "L" }).map({ _ in 1 }).reduce(0, +) }
    var fairwayM:  Int { return scores.filter({ $0.Fairway == "M" }).map({ _ in 1 }).reduce(0, +) }

    var penaltyFront9:  Int { return scores.filter({ $0.Hole < 10 }).map({ $0.Penalty }).reduce(0, +) }
    var penaltyBack9:  Int { return scores.filter({ $0.Hole > 9 }).map({ $0.Penalty }).reduce(0, +) }
    var penaltyBack18:  Int {return scores.reduce(0, {$0 + $1.Penalty}) }

    var puttsFront9:  Int { return scores.filter({ $0.Hole < 10 }).map({ $0.Putts }).reduce(0, +) }
    var puttsBack9:  Int { return scores.filter({ $0.Hole > 9 }).map({ $0.Putts }).reduce(0, +) }
    var puttsBack18:  Int {return scores.reduce(0, {$0 + $1.Putts}) }

    var greenRecorded: Int { return scores.filter({ !$0.Green.isEmpty }).map({ _ in 1 }).reduce(0, +) }
    var greensFront9:  Int { return scores.filter({ $0.Green == "H" && $0.Hole < 10}).map({ _ in 1 }).reduce(0, +) }
    var greensBack9:  Int { return scores.filter({ $0.Green == "H" && $0.Hole > 9 }).map({ _ in 1 }).reduce(0, +) }
    var greensBack18:  Int { return scores.filter({ $0.Green == "H" }).map({ _ in 1 }).reduce(0, +) }
    var greensH:  Int { return scores.filter({ $0.Green == "H" }).map({ _ in 1 }).reduce(0, +) }
    var greensR:  Int { return scores.filter({ $0.Green == "R" }).map({ _ in 1 }).reduce(0, +) }
    var greensL:  Int { return scores.filter({ $0.Green == "L" }).map({ _ in 1 }).reduce(0, +) }
    var greensO:  Int { return scores.filter({ $0.Green == "O" }).map({ _ in 1 }).reduce(0, +) }
    var greensS:  Int { return scores.filter({ $0.Green == "S" }).map({ _ in 1 }).reduce(0, +) }

    var scoreFront9:  Int { return scores.filter({ $0.Hole < 10 && $0.Hole <= currentHole}).map({ $0.Score }).reduce(0, +) }
    var scoreBack9:  Int { return scores.filter({ $0.Hole >= 10 && $0.Hole <= currentHole}).map({ $0.Score }).reduce(0, +) }
    var scoreBack18:  Int { return scores.reduce(0, {$0 + $1.Score}) }
    var scoreCurrent:  Int { return scores.filter({ $0.Hole <= currentHole }).map({ $0.Score }).reduce(0, +) }

}
