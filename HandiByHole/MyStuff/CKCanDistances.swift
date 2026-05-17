//
//  CKCanDistances.swift
//  HandiByHole
//
//  Created by Coding Assistant on 2026-05-16.
//

import CloudKit

struct CKCanDistance: Identifiable, Codable {
    var id: CKRecord.ID
    var entryDate: Foundation.Date
    var Hole: Int
    var Club: String
    var Distance: Double
    var record: CKRecord

    init?(record: CKRecord) {
        self.id = record.recordID
        self.entryDate = record["Date"] as? Foundation.Date ?? .now
        self.Hole = record["Hole"] as? Int ?? 1
        self.Club = record["Club"] as? String ?? ""
        self.Distance = record["Distance"] as? Double ?? 0
        self.record = record
    }

    init?(entryDate: Foundation.Date = .now, Hole: Int, Club: String, Distance: Double) {
        let record = CKRecord(recordType: myRecordType.CanDistance.rawValue)
        record["Date"] = entryDate as CKRecordValue
        record["Hole"] = Hole
        record["Club"] = Club
        record["Distance"] = Distance
        self.init(record: record)
    }

    enum CodingKeys: String, CodingKey {
        case id
        case entryDate = "Date"
        case Hole
        case Club
        case Distance
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id.recordName, forKey: .id)
        try container.encode(entryDate, forKey: .entryDate)
        try container.encode(Hole, forKey: .Hole)
        try container.encode(Club, forKey: .Club)
        try container.encode(Distance, forKey: .Distance)
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let recordName = try container.decode(String.self, forKey: .id)
        self.id = CKRecord.ID(recordName: recordName)
        self.entryDate = try container.decode(Foundation.Date.self, forKey: .entryDate)
        self.Hole = try container.decode(Int.self, forKey: .Hole)
        self.Club = try container.decode(String.self, forKey: .Club)
        self.Distance = try container.decode(Double.self, forKey: .Distance)

        self.record = CKRecord(recordType: myRecordType.CanDistance.rawValue)
        self.record["Date"] = entryDate as CKRecordValue
        self.record["Hole"] = Hole as CKRecordValue
        self.record["Club"] = Club as CKRecordValue
        self.record["Distance"] = Distance as CKRecordValue
    }

    func update(entryDate: Foundation.Date = .now,
                Hole: Int,
                Club: String,
                Distance: Double) -> CKCanDistance? {
        let record = record
        record["Date"] = entryDate as CKRecordValue
        record["Hole"] = Hole
        record["Club"] = Club
        record["Distance"] = Distance
        return CKCanDistance(record: record)
    }
}
