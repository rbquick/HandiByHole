//
//  HandiByHoleApp.swift
//  HandiByHole
//
//  Created by Brian Quick on 2026-10-01.
//

import SwiftUI

@main
struct HandiByHoleApp: App {
    @StateObject var modelscore = ModelScore()
    @StateObject var modelcanscore = ModelCanScore()
    @StateObject var modelcandistance = ModelCanDistance()
    @StateObject var modelpar = ModelPar()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(modelscore)
                .environmentObject(modelcanscore)
                .environmentObject(modelcandistance)
                .environmentObject(modelpar)
        }
    }
}
