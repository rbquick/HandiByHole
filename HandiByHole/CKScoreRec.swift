//
//  CKScoreRec.swift
//  icloudIOS

import SwiftUI
import CloudKit

struct CKScoreRec: Identifiable, Codable {
    var id: CKRecord.ID
    var PlayerID: Int
    var GameID: Int
    var Hole: Int
    var Score: Int
    var Fairway: String
    var Green: String
    var Putts: Int
    var Bunker: Int
    var Penalty: Int
    var record: CKRecord
    init?(record: CKRecord) {
        self.id = record.recordID
        self.PlayerID = record["PlayerID"] as? Int ?? 1
        self.GameID = record["GameID"] as? Int ?? 1
        self.Hole = record["Hole"] as? Int ?? 1
        self.Score = record["Score"] as? Int ?? 1
        self.Fairway = record["Fairway"] as? String ?? ""
        self.Green = record["Green"] as? String ?? ""
        self.Putts = record["Putts"] as? Int ?? 1
        self.Bunker = record["Bunker"] as? Int ?? 1
        self.Penalty = record["Penalty"] as? Int ?? 1
        self.record = record
    }
    init?(PlayerID: Int,
          GameID: Int,
          Hole: Int,
          Score: Int,
          Fairway: String,
          Green: String,
          Putts: Int,
          Bunker: Int,
          Penalty: Int) {
        let record = CKRecord(recordType: myRecordType.Score.rawValue)
        record["PlayerID"] = PlayerID
        record["GameID"] = GameID
        record["Hole"] = Hole
        record["Score"] = Score
        record["Fairway"] = Fairway
        record["Green"] = Green
        record["Putts"] = Putts
        record["Bunker"] = Bunker
        record["Penalty"] = Penalty
        self.init(record: record)
    }
    
    // Coding Keys for Codable
    enum CodingKeys: String, CodingKey {
        case id
        case PlayerID
        case GameID
        case Hole
        case Score
        case Fairway
        case Green
        case Putts
        case Bunker
        case Penalty
    }
    // Codable conformance
        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(id.recordName, forKey: .id) // Storing record ID's recordName
            try container.encode(PlayerID, forKey: .PlayerID)
            try container.encode(GameID, forKey: .GameID)
            try container.encode(Hole, forKey: .Hole)
            try container.encode(Score, forKey: .Score)
            try container.encode(Fairway, forKey: .Fairway)
            try container.encode(Green, forKey: .Green)
            try container.encode(Putts, forKey: .Putts)
            try container.encode(Bunker, forKey: .Bunker)
            try container.encode(Penalty, forKey: .Penalty)
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let recordName = try container.decode(String.self, forKey: .id)
            self.id = CKRecord.ID(recordName: recordName)
            self.PlayerID = try container.decode(Int.self, forKey: .PlayerID)
            self.GameID = try container.decode(Int.self, forKey: .GameID)
            self.Hole = try container.decode(Int.self, forKey: .Hole)
            self.Score = try container.decode(Int.self, forKey: .Score)
            self.Fairway = try container.decode(String.self, forKey: .Fairway)
            self.Green = try container.decode(String.self, forKey: .Green)
            self.Putts = try container.decode(Int.self, forKey: .Putts)
            self.Bunker = try container.decode(Int.self, forKey: .Bunker)
            self.Penalty = try container.decode(Int.self, forKey: .Penalty)
            
            // Creating a CKRecord for completeness, though it won't have full data
            self.record = CKRecord(recordType: "Score")
            // self.record.recordID = self.id  // ERROR: Cannot assign to property: 'recordID' is a get-only property
            self.record["PlayerID"] = PlayerID as CKRecordValue
            self.record["GameID"] = GameID as CKRecordValue
            self.record["Hole"] = Hole as CKRecordValue
            self.record["Score"] = Score as CKRecordValue
            self.record["Fairway"] = Fairway as CKRecordValue
            self.record["Green"] = Green as CKRecordValue
            self.record["Putts"] = Putts as CKRecordValue
            self.record["Bunker"] = Bunker as CKRecordValue
            self.record["Penalty"] = Penalty as CKRecordValue
        }
    
    
    
    func update(PlayerID: Int,
                GameID: Int,
                Hole: Int,
                Score: Int,
                Fairway: String,
                Green: String,
                Putts: Int,
                Bunker: Int,
                Penalty: Int) -> CKScoreRec? {
        let record = record
        record["PlayerID"] = PlayerID
        record["GameID"] = GameID
        record["Hole"] = Hole
        record["Score"] = Score
        record["Fairway"] = Fairway
        record["Green"] = Green
        record["Putts"] = Putts
        record["Bunker"] = Bunker
        record["Penalty"] = Penalty
        return CKScoreRec(record: record)
    }
    
    static func example1() -> CKScoreRec {
        return CKScoreRec(PlayerID: 32, GameID: 1, Hole: 1, Score: 4, Fairway: "H", Green: "H", Putts: 2, Bunker: 3, Penalty: 4)!
    }
    static func example2() -> CKScoreRec {
        return CKScoreRec(PlayerID: 2, GameID: 2, Hole: 1, Score: 4, Fairway: "H", Green: "H", Putts: 2, Bunker: 3, Penalty: 4)!
    }
}
