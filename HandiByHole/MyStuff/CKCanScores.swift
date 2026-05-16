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
    var Club: String
    var Distance: Double
    var Putt1st: Double
    var Putt2nd: Double
    var Putt3rd: Double
    var SandSave: Bool
    var UPDown: Bool
    var MatchScore: Int
    var MatchUpDown: Int
    var record: CKRecord
    init?(record: CKRecord) {
        self.id = record.recordID
        self.Hole = record["Hole"] as? Int ?? 1
        self.Club = record["Club"] as? String ?? ""
        self.Distance = record["Distance"] as? Double ?? 0
        self.Putt1st = record["Putt1st"] as? Double ?? 0
        self.Putt2nd = record["Putt2nd"] as? Double ?? 0
        self.Putt3rd = record["Putt3rd"] as? Double ?? 0
        self.SandSave = record["SandSave"] as? Bool ?? false
        self.UPDown = record["UPDown"] as? Bool ?? false
        self.MatchScore = record["MatchScore"] as? Int ?? 0
        self.MatchUpDown = record["MatchUpDown"] as? Int ?? 0
        self.record = record
    }
    init?(Hole: Int, Club: String, Distance: Double, Putt1st: Double, Putt2nd: Double, Putt3rd: Double, SandSave: Bool, UPDown: Bool, MatchScore: Int, MatchUpDown: Int) {
        let record = CKRecord(recordType: myRecordType.CanScore.rawValue)
        record["Hole"] = Hole
        record["Club"] = Club
        record["Distance"] = Distance
        record["Putt1st"] = Putt1st
        record["Putt2nd"] = Putt2nd
        record["Putt3rd"] = Putt3rd
        record["SandSave"] = SandSave
        record["UPDown"] = UPDown
        record["MatchScore"] = MatchScore
        record["MatchUpDown"] = MatchUpDown
        self.init(record: record)
    }
    enum CodingKeys: String, CodingKey {
        case id
        case Hole
        case Club
        case Distance
        case Putt1st
        case Putt2nd
        case Putt3rd
        case SandSave
        case UPDown
        case MatchScore
        case MatchUpDown
    }
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id.recordName, forKey: .id)
        try container.encode(Hole, forKey: .Hole)
        try container.encode(Club, forKey: .Club)
        try container.encode(Distance, forKey: .Distance)
        try container.encode(Putt1st, forKey: .Putt1st)
        try container.encode(Putt2nd, forKey: .Putt2nd)
        try container.encode(Putt3rd, forKey: .Putt3rd)
        try container.encode(SandSave, forKey: .SandSave)
        try container.encode(UPDown, forKey: .UPDown)
        try container.encode(MatchScore, forKey: .MatchScore)
        try container.encode(MatchUpDown, forKey: .MatchUpDown)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let recordName = try container.decode(String.self, forKey: .id)
        self.id = CKRecord.ID(recordName: recordName)
        self.Hole = try container.decode(Int.self, forKey: .Hole)
        self.Club = try container.decode(String.self, forKey: .Club)
        self.Distance = try container.decode(Double.self, forKey: .Distance)
        self.Putt1st = try container.decode(Double.self, forKey: .Putt1st)
        self.Putt2nd = try container.decode(Double.self, forKey: .Putt2nd)
        self.Putt3rd = try container.decode(Double.self, forKey: .Putt3rd)
        self.SandSave = try container.decode(Bool.self, forKey: .SandSave)
        self.UPDown = try container.decode(Bool.self, forKey: .UPDown)
        self.MatchScore = try container.decode(Int.self, forKey: .MatchScore)
        self.MatchUpDown = try container.decode(Int.self, forKey: .MatchUpDown)
    
        self.record = CKRecord(recordType: myRecordType.CanScore.rawValue)
        self.record["Hole"] = Hole as CKRecordValue
        self.record["Club"] = Club as CKRecordValue
        self.record["Hole"] = Hole as CKRecordValue
        self.record["Distance"] = Distance as CKRecordValue
        self.record["Putt1st"] = Putt1st as CKRecordValue
        self.record["Putt2nd"] = Putt2nd as CKRecordValue
        self.record["Putt3rd"] = Putt3rd as CKRecordValue
        self.record["SandSave"] = SandSave as CKRecordValue
        self.record["UPDown"] = UPDown as CKRecordValue
        self.record["MatchScore"] = MatchScore as CKRecordValue
        self.record["MatchUpDown"] = MatchUpDown as CKRecordValue
    }
    func update(Hole: Int,
                Club: Int,
                Distance: Double,
                Putt1st: Double,
                Putt2nd: Double,
                Putt3rd: Double,
                SandSave: Int,
                UpDown: Int,
                MatchScore: Int,
                MatchUpDown: Int) -> CKCanScoreRec? {
        let record = record
        record["Hole"] = Hole
        record["Club"] = Club
        record["Distance"] = Distance
        record["Putt1st"] = Putt1st
        record["Putt2nd"] = Putt2nd
        record["Putt3rd"] = Putt3rd
        record["SandSave"] = SandSave
        record["UpDown"] = UpDown
        record["MatchScore"] = MatchScore
        record["MatchUpDown"] = MatchUpDown
        return CKCanScoreRec(record: record)
    }
}
