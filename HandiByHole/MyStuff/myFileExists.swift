//
//  myFileExists.swift
//  HandicappMulti
//
//  Created by Brian Quick on 2024-06-15.
//

import Foundation

func myFileExists(fileName: String) -> Bool {
    let fileURL = getDocumentsDirectory().appendingPathComponent(fileName)
    return FileManager.default.fileExists(atPath: fileURL.path)
}

func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
}
