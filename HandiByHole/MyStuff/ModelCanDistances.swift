//
//  ModelCanDistances.swift
//  HandiByHole
//
//  Created by Coding Assistant on 2026-05-16.
//

import CloudKit
import SwiftUI

class ModelCanDistance: ObservableObject {
    @Published var canDistances: [CKCanDistance] = []

    let JSONFilename = "canDistances.json"

    init() {
        read()
        if canDistances.count == 0 {
            previewData()
        }
    }

    @MainActor static let currentModel = ModelCanDistance()

    func previewData() {
        canDistances.removeAll()
        for i in 1...18 {
            let myRec = CKCanDistance(Hole: i, Club: "3-Wood", Distance: 200)!
            canDistances.append(myRec)
        }
    }

    func updateHoleDetails(hole: Int, club: String, distance: Double) {
        guard canDistances.indices.contains(hole - 1) else { return }

        if let updatedRec = canDistances[hole - 1].update(Hole: hole, Club: club, Distance: distance) {
            canDistances[hole - 1] = updatedRec
        }
    }

    func read() {
        do {
            try readFromJSONFile(filename: JSONFilename, model: &canDistances)
        } catch {
            previewData()
        }
    }

    func save() {
        do {
            try saveToJSONFile(items: canDistances, filename: JSONFilename)
        } catch {
            print("Error saving JSON file")
        }
    }
}
