//
//  CKParRec.swift
//  icloudIOS
//
//  Created by Brian Quick on 2021-09-03.
//

import SwiftUI
import CloudKit

struct CKParRec: Identifiable, Codable {
    let id: CKRecord.ID
    let CourseID: Int
    let TeeID: Int
    let Hole: Int
    let Par: Int
    let Handicap: Int
    let Yardage: Int
    let record: CKRecord
    init?(record: CKRecord) {
        self.id = record.recordID
        self.CourseID = record["CourseID"] as? Int ?? 1
        self.TeeID = record["TeeID"] as? Int ?? 1
        self.Hole = record["Hole"] as? Int ?? 1
        self.Par = record["Par"] as? Int ?? 1
        self.Handicap = record["Handicap"] as? Int ?? 1
        self.Yardage = record["Yardage"] as? Int ?? 1
        self.record = record
    }
    init?(CourseID: Int,
          TeeID: Int,
          Hole: Int,
          Par: Int,
          Handicap: Int,
          Yardage: Int) {
        let record = CKRecord(recordType: myRecordType.Par.rawValue)
        record["CourseID"] = CourseID
        record["TeeID"] = TeeID
        record["Hole"] = Hole
        record["Par"] = Par
        record["Handicap"] = Handicap
        record["Yardage"] = Yardage
        self.init(record: record)
    }
   
    // Keys for encoding/decoding
    enum CodingKeys: String, CodingKey {
        case id, CourseID, TeeID, Hole, Par, Handicap, Yardage
    }
    
    // MARK: - Codable Conformance

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let recordName = try container.decode(String.self, forKey: .id)
            self.id = CKRecord.ID(recordName: recordName)
            self.CourseID = try container.decode(Int.self, forKey: .CourseID)
            self.TeeID = try container.decode(Int.self, forKey: .TeeID)
            self.Hole = try container.decode(Int.self, forKey: .Hole)
            self.Par = try container.decode(Int.self, forKey: .Par)
            self.Handicap = try container.decode(Int.self, forKey: .Handicap)
            self.Yardage = try container.decode(Int.self, forKey: .Yardage)

            // Create the CKRecord
            self.record = CKRecord(recordType: myRecordType.Par.rawValue, recordID: self.id)
            self.record["CourseID"] = CourseID as CKRecordValue
            self.record["TeeID"] = TeeID as CKRecordValue
            self.record["Hole"] = Hole as CKRecordValue
            self.record["Par"] = Par as CKRecordValue
            self.record["Handicap"] = Handicap as CKRecordValue
            self.record["Yardage"] = Yardage as CKRecordValue
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(id.recordName, forKey: .id)
            try container.encode(CourseID, forKey: .CourseID)
            try container.encode(TeeID, forKey: .TeeID)
            try container.encode(Hole, forKey: .Hole)
            try container.encode(Par, forKey: .Par)
            try container.encode(Handicap, forKey: .Handicap)
            try container.encode(Yardage, forKey: .Yardage)
        }

    
    
    func update(CourseID: Int,
                TeeID: Int,
                Hole: Int,
                Par: Int,
                Handicap: Int,
                Yardage: Int) -> CKParRec? {
        let record = record
        record["CourseID"] = CourseID
        record["TeeID"] = TeeID
        record["Hole"] = Hole
        record["Par"] = Par
        record["Handicap"] = Handicap
        record["Yardage"] = Yardage
        return CKParRec(record: record)
    }
    static func example1() -> CKParRec {
        return CKParRec(CourseID: 1, TeeID: 1, Hole: 1, Par: 4, Handicap: 1, Yardage: 111)!
    }
}
