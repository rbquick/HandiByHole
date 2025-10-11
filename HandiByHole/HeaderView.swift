//
//  HeaderView.swift
//  HandiByHole
//
//  Created by Brian Quick on 2025-10-09.
//

import SwiftUI

struct HeaderView: View {
    @EnvironmentObject var modelscore: ModelScore
    @EnvironmentObject var modelpar: ModelPar
    var body: some View {
        VStack {
            HStack {
                
                if modelscore.currentHole >= 9 {
                    
                    Text("F:")
                    Text("\(modelscore.scoreFront9)")
                    
                }
                if modelscore.currentHole == 18 {
                    
                    Text("B:")
                    Text("\(modelscore.scoreBack9)")
                    
                }
                
                Text("Score:")
                Text("\(modelscore.scoreCurrent)")
            }
            HStack {
                
                Text("Hole: \(modelscore.currentHole) ")
                Text("Par: \(modelpar.getPar(hole: modelscore.currentHole)) ")
            }
            
        }
        .frame(maxWidth: .infinity, minHeight: 120)
        .background(Color.blue)
        .foregroundColor(.white)
        .cornerRadius(10)
        .font(.largeTitle)
    }
}

#Preview {
    HeaderView()
        .environmentObject(ModelScore())
        .environmentObject(ModelPar())
}
