//
//  Untitled 2.swift
//  HandiByHole
//
//  Created by Brian Quick on 2025-05-06.
//

import SwiftUI
import CloudKit

class ModelCanScore: ObservableObject {
    @Published var canScores: [CKCanScoreRec] = []
    @Published var showMatch: Bool = true
    @Published var matchFront: Int = 0
    @Published var matchBack: Int = 0
    @Published var match18: Int = 0
    @Published var dollars: Int = 0
    
    var currentHole = 18
    
    let JSONFilename = "canScores.json"
    
    
    init() {
        read()
        if canScores.count == 0 {
                    previewData()
                }
    }
    
    
    func previewData() {
        canScores.removeAll()
        for i in 1...18 {
            let myRec = CKCanScoreRec(Hole: i, Club: "3 Wood", Distance: 200, PutLength: 20, SandSave: false, UPDown: false, MatchScore: 4, MatchUpDown: 1)!
            canScores.append(myRec)
        }
    }
    
    @MainActor static let currentModel = ModelCanScore()
    
    func read() {
        do {
           try readFromJSONFile(filename: JSONFilename, model: &canScores)
        } catch {
            previewData()
        }
    }
    func save() {
        do {
            try saveToJSONFile(items: canScores, filename: JSONFilename)
        } catch {
            print("Error saving JSON file")
        }
    }
    var scoreFront9:  Int {
        return canScores.filter({ $0.Hole < 10 && $0.Hole <= currentHole}).map({ $0.MatchScore }).reduce(0, +)
    }
    var scoreBack9:  Int {
        return canScores.filter({ $0.Hole >= 10 && $0.Hole <= currentHole}).map({ $0.MatchScore }).reduce(0, +)
    }
    var scoreBack18:  Int {
        return canScores.filter({ $0.Hole <= currentHole}).map({ $0.MatchScore }).reduce(0, +)
    }
    var scoreCurrent:  Int {
        return canScores.filter({ $0.Hole <= currentHole }).map({ $0.MatchScore }).reduce(0, +)
    }
}
