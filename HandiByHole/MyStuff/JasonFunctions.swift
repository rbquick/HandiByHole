//
//  JasonFunctions.swift
//  HandiByHole
//
//  Created by Brian Quick on 2025-04-27.
//
/*
 The following is required put the file in the files.app on ios
 Modify your Info.plist:
 Add a key: Application supports iTunes file sharing (UIFileSharingEnabled) → set to YES
 Add a key: Supports opening documents in place (LSSupportsOpeningDocumentsInPlace) → set to YES
 (This will allow Files app and other apps to see your files.)
 */

import SwiftUI
import CloudKit

func readFromJSONFile<T: Decodable>(filename: String, model: inout [T]) throws {
    var msgList: [String] = []
    do {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsDirectory.appendingPathComponent(filename)
        
        let jsonData = try Data(contentsOf: fileURL)
        model = try JSONDecoder().decode([T].self, from: jsonData)
        
        var myadds = [CKRecord]()
        for _ in model {
            myadds.append(CKRecord(recordType: "Adds"))
        }
        msgList.append("Read \(model.count) records from \(fileURL)")
    } catch {
        msgList.append("Failed to read \(filename): \(error)")
    }
    print(msgList.joined(separator: "\n"))
}
func saveToJSONFile<T: Encodable>(items: [T], filename: String) throws {
    let encoder = JSONEncoder()
    encoder.outputFormatting = .prettyPrinted
    let jsonData = try encoder.encode(items)
    

        let fileURL = getDocumentsDirectory().appendingPathComponent(filename)
        try jsonData.write(to: fileURL)
        print("File saved to \(fileURL)")
    
}
func saveJASONToiCloud<T: Encodable>(items: [T], filename: String) throws {
    let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let jsonData = try encoder.encode(items)
    saveToICloud(fileName: filename, data: jsonData)
}
func saveToICloud(fileName: String, data: Data) {
    let fileManager = FileManager.default

    guard let iCloudURL = fileManager.url(forUbiquityContainerIdentifier: nil)?
        .appendingPathComponent("Documents")
        .appendingPathComponent(fileName) else {
        print("iCloud container not available")
        return
    }

    do {
        try fileManager.createDirectory(at: iCloudURL.deletingLastPathComponent(), withIntermediateDirectories: true, attributes: nil)
        try data.write(to: iCloudURL, options: .atomic)
        print("Saved to iCloud: \(iCloudURL)")
    } catch {
        print("Error saving to iCloud: \(error)")
    }
}
func deleteFromICloud(fileName: String) {
    let fileManager = FileManager.default

    guard let iCloudURL = fileManager.url(forUbiquityContainerIdentifier: nil)?
        .appendingPathComponent("Documents")
        .appendingPathComponent(fileName) else {
        print("iCloud container not available")
        return
    }

    do {
        if fileManager.fileExists(atPath: iCloudURL.path) {
            try fileManager.removeItem(at: iCloudURL)
            print("Deleted from iCloud: \(iCloudURL)")
        } else {
            print("File does not exist at: \(iCloudURL)")
        }
    } catch {
        print("Error deleting file from iCloud: \(error)")
    }
}
