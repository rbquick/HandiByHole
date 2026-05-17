//
//  ContentView.swift
//  HandiByHole
//
//  Created by Brian Quick on 2025-04-26.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var modelscore: ModelScore
    @EnvironmentObject var modelcanscore: ModelCanScore
    @EnvironmentObject var modelcandistance: ModelCanDistance
    @EnvironmentObject var modelpar: ModelPar
    
    var body: some View {
        VStack {
            HoleEntry()
        }
        .padding()
    }
}

#Preview {
    ContentView()
        .environmentObject(ModelScore())
        .environmentObject(ModelCanScore())
        .environmentObject(ModelCanDistance())
        .environmentObject(ModelPar())

}

extension ContentView {
   
}
