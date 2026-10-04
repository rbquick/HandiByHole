//
//  Untitled.swift
//  HandiByHole
//
//  Created by Brian Quick on 2025-05-06.
//

import CloudKit

struct CKCanScoreRec: Identifiable, Codable {
    var id: CKRecord.ID
    var Hole: Int
    var UPDown: Bool
    var MatchScore: Int
    var MatchUpDown: Int
    var record: CKRecord

    init?(record: CKRecord) {
        self.id = record.recordID
        self.Hole = record["Hole"] as? Int ?? 1
        self.UPDown = record["UPDown"] as? Bool ?? false
        self.MatchScore = record["MatchScore"] as? Int ?? 0
        self.MatchUpDown = record["MatchUpDown"] as? Int ?? 0
        self.record = record
    }

    init?(Hole: Int, UPDown: Bool, MatchScore: Int, MatchUpDown: Int) {
        let record = CKRecord(recordType: myRecordType.CanScore.rawValue)
        record["Hole"] = Hole
        record["UPDown"] = UPDown
        record["MatchScore"] = MatchScore
        record["MatchUpDown"] = MatchUpDown
        self.init(record: record)
    }

    enum CodingKeys: String, CodingKey {
        case id
        case Hole
        case UPDown
        case MatchScore
        case MatchUpDown
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id.recordName, forKey: .id)
        try container.encode(Hole, forKey: .Hole)
        try container.encode(UPDown, forKey: .UPDown)
        try container.encode(MatchScore, forKey: .MatchScore)
        try container.encode(MatchUpDown, forKey: .MatchUpDown)
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let recordName = try container.decode(String.self, forKey: .id)
        self.id = CKRecord.ID(recordName: recordName)
        self.Hole = try container.decode(Int.self, forKey: .Hole)
        self.UPDown = try container.decode(Bool.self, forKey: .UPDown)
        self.MatchScore = try container.decode(Int.self, forKey: .MatchScore)
        self.MatchUpDown = try container.decode(Int.self, forKey: .MatchUpDown)

        self.record = CKRecord(recordType: myRecordType.CanScore.rawValue)
        self.record["Hole"] = Hole as CKRecordValue
        self.record["UPDown"] = UPDown as CKRecordValue
        self.record["MatchScore"] = MatchScore as CKRecordValue
        self.record["MatchUpDown"] = MatchUpDown as CKRecordValue
    }

    func update(Hole: Int,
                UpDown: Int,
                MatchScore: Int,
                MatchUpDown: Int) -> CKCanScoreRec? {
        let record = record
        record["Hole"] = Hole
        record["UpDown"] = UpDown
        record["MatchScore"] = MatchScore
        record["MatchUpDown"] = MatchUpDown
        return CKCanScoreRec(record: record)
    }
}
