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

    func addHoleDetails(hole: Int, club: String, distance: Double) {
        guard let newRec = CKCanDistance(Hole: hole, Club: club, Distance: distance) else { return }
        canDistances.append(newRec)
    }

    func newestRecord(for hole: Int) -> CKCanDistance? {
        canDistances
            .filter { $0.Hole == hole }
            .sorted(by: newestFirst)
            .first
    }

    func newestRecord() -> CKCanDistance? {
        canDistances
            .sorted(by: newestFirst)
            .first
    }

    func delete(records: [CKCanDistance]) {
        let idsToDelete = Set(records.map(\.id))
        canDistances.removeAll { idsToDelete.contains($0.id) }
    }

    func records(for club: String) -> [CKCanDistance] {
        canDistances
            .filter { $0.Club == club }
            .sorted(by: newestFirst)
    }

    func averageDistance(for club: String) -> Double? {
        let distances = canDistances
            .filter { $0.Club == club }
            .map { $0.Distance }
        guard !distances.isEmpty else { return nil }
        return distances.reduce(0, +) / Double(distances.count)
    }

    private func newestFirst(_ lhs: CKCanDistance, _ rhs: CKCanDistance) -> Bool {
        if lhs.entryDate == rhs.entryDate {
            return lhs.Hole > rhs.Hole
        }
        return lhs.entryDate > rhs.entryDate
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
