//
//  HandiByHoleApp.swift
//  HandiByHole
//
//  Created by Brian Quick on 2025-04-26.
//

import SwiftUI

@main
struct HandiByHoleApp: App {
    @StateObject var modelscore = ModelScore()
    @StateObject var modelcanscore = ModelCanScore()
    @StateObject var modelpar = ModelPar()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(modelscore)
                .environmentObject(modelcanscore)
                .environmentObject(modelpar)
        }
    }
}
