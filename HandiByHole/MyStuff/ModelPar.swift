//
//  ModelPar.swift
//  icloudIOS
//
//  Created by Brian Quick on 2021-09-03.
//

import SwiftUI
import CloudKit

class ModelPar: ObservableObject {
    @Published var pars = [CKParRec]()
    @Published var isChanged = 0
    
    @Published var currentCoureID: Int = 1
    @Published var currentTeeID: Int = 3
    

    let JSONFilename = "pars.json"
    var addRequired = false

    var isTracing: Bool = false
    func tracing(function: String) {
        if isTracing {
            print("ModelPar \(function) ")
            myLogger.log("ModelPar \(function)")
        }
    }
    // init to a non-existing course/tee so the first display will be a change
    init() {
     //   CreateParsfor(courseID: 1, teeID: 1)
        tracing(function: "init")
        read()
        if pars.count == 0 {
            previewData(courseID: 1, teeID: 3)
        }
    }

    @MainActor static let currentModel = ModelPar()

    func previewData(courseID: Int, teeID: Int) {
        pars.removeAll()
        for i in 1...18 {
            let myRec = CKParRec(CourseID: courseID, TeeID: teeID, Hole: i, Par: i, Handicap: 9, Yardage: 111)!
            pars.append(myRec)
        }
    }

    var parFront9:  Int { return pars.filter({ $0.Hole < 10 }).map({ $0.Par }).reduce(0, +) }
    var parBack9:  Int { return pars.filter({ $0.Hole > 9 }).map({ $0.Par }).reduce(0, +) }
    var parBack18:  Int { return pars.reduce(0, {$0 + $1.Par}) }

    var yardageFront9:  Int { return pars.filter({ $0.Hole < 10 }).map({ $0.Yardage }).reduce(0, +) }
    var yardageBack9:  Int { return pars.filter({ $0.Hole > 9 }).map({ $0.Yardage }).reduce(0, +) }
    var yardageBack18:  Int { return pars.reduce(0, {$0 + $1.Yardage}) }

    func read() {
        do {
            try readFromJSONFile(filename: JSONFilename, model: &pars)
            print("Pars Read Maybe \(pars.count)")
        } catch {
            previewData(courseID: 1, teeID: 3)
            print("error Reading Pars JSON File \(error)")
        }
    }
  func getPar(hole: Int) -> Int {
      return pars.first(where: { $0.Hole == hole && $0.CourseID == currentCoureID && $0.TeeID == currentTeeID})?.Par ?? 0
    }
    func getInputDistance(hole: Int) -> Int {
        let par = pars.first(where: { $0.Hole == hole && $0.CourseID == currentCoureID && $0.TeeID == currentTeeID})?.Par ?? 0
        let yardage = pars.first(where: { $0.Hole == hole && $0.CourseID == currentCoureID && $0.TeeID == currentTeeID})?.Yardage ?? 0
        let distance = par == 3 ? yardage : yardage / 2
        return distance
    }
    func getYardage(hole: Int) -> Int {
            let yardage = pars.first(where: { $0.Hole == hole && $0.CourseID == currentCoureID && $0.TeeID == currentTeeID})?.Yardage ?? 0
            return yardage
        }
}
