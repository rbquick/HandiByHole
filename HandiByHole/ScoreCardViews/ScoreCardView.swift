//
//  ScoreCardView.swift
//  HandiByHole
//
//  Created by Brian Quick on 2025-05-10.
//

import SwiftUI

struct ScoreCardView: View {
    @EnvironmentObject var modelscore: ModelScore
    @EnvironmentObject var modelpar: ModelPar
    @EnvironmentObject var modelcanscore: ModelCanScore
    @Environment(\.dismiss) private var dismiss
    
    @State var totalWidth: CGFloat = 1.0
    @State var cellCount: Int = 12
    @State var baseWidth: Double = 1.0
    
    @State var upDownFront: Int = 0
    @State var upDownBack: Int = 0
    
    var body: some View {
        Spacer()
        VStack {
            HoleRowView(title: "Hole", numbers: Array(1...9), trailingLabels: ["OUT"], myColor: modelcanscore.matchFront < 0 ? .red: .blue)
            Text(" ")
            ParRowView(title: "Par", numbers: getPars(holes: 1), rating: Array(repeating: "", count: 9),trailingLabels: [35])
            Text(" ")
            let (frontScores, frontRatings) = getScores(holes: 1)
            let (frontcanScores, frontcanRatings) = getcanScores(holes: 1)
            ParRowView(title: "Me", numbers: frontScores, rating: frontRatings, trailingLabels: [modelscore.scoreFront9])
            Text(" ")
            if modelcanscore.showMatch {
                
                ParRowView(title: "Reg", numbers: frontcanScores, rating: frontcanRatings, trailingLabels: [modelcanscore.scoreFront9])
            Text(" ")
                ParRowView(title: "U/D", numbers: getUpDown(holes: 1), rating: Array(repeating: "", count: 9), trailingLabels: [modelcanscore.matchFront])
            Text(" ")
            }
            HoleRowView(title: "Hole", numbers: Array(10...18), trailingLabels: ["IN", "TOT"], myColor: modelcanscore.matchBack < 0 ? .red: .blue)
            Text(" ")
            ParRowView(title: "Par", numbers: getPars(holes: 10), rating: Array(repeating: "", count: 9), trailingLabels: [35, 70])
            Text(" ")
            let (backScores, backRatings) = getScores(holes: 10)
            let (backcanScores, backcanRatings) = getcanScores(holes: 10)
            ParRowView(title: "Sco", numbers: backScores, rating: backRatings, trailingLabels: [modelscore.scoreBack9, modelscore.scoreCurrent])
            Text(" ")
            if modelcanscore.showMatch {
                ParRowView(title: "Reg", numbers: backcanScores, rating: backcanRatings, trailingLabels: [modelcanscore.scoreBack9, modelcanscore.scoreBack18])
                Text(" ")
                ParRowView(title: "U/D", numbers: getUpDown(holes: 10), rating: Array(repeating: "", count: 9), trailingLabels: [modelcanscore.matchBack, modelcanscore.match18])
            }
        }
        .onAppear() {
            modelcanscore.currentHole = modelscore.currentHole
        }
        Spacer()
        Button("Close") {
            dismiss()
        }
        .padding()
        .background(Color.blue)
        .foregroundColor(.white)
        .cornerRadius(8)
    }
    
}

#Preview {
    ScoreCardView()
        .environmentObject(ModelScore())
        .environmentObject(ModelPar())
        .environmentObject(ModelCanScore())
}
extension ScoreCardView {
    func getPars(holes: Int) -> [Int] {
        var pars: [Int] = []
        for ind in 0...8 {
            pars.append(modelpar.getPar(hole: ind+holes))
        }
        return pars
    }
    func getCanScore(holes: Int) -> [Int] {
        var scores: [Int] = []
        for ind in 0...8 {
            if ind+holes <= modelscore.currentHole {
                scores.append(modelcanscore.canScores[ind+holes-1].MatchScore)
            } else {
                scores.append(0)
            }
        }
        return scores
    }
    func getUpDown(holes: Int) -> [Int] {
        var upDown: [Int] = []
        for _ in 0...8 {
            upDown.append(0)
        }
        var totalUp: Int = 0
        for ind in 0...8 {
            
            if ind+holes <= modelscore.currentHole {
                totalUp = modelscore.scores[ind+holes-1].Score < modelcanscore.canScores[ind+holes-1].MatchScore ? totalUp + 1 : modelscore.scores[ind+holes-1].Score > modelcanscore.canScores[ind+holes-1].MatchScore ? totalUp - 1 : totalUp
                upDown[ind] = totalUp
        }

        }
        
        
        return upDown
    }
    func getScores(holes: Int) -> ([Int], [String]) {
        var scores: [Int] = []
        var rating: [String] = []
        for ind in 0...8 {
            if ind+holes <= modelscore.currentHole {
                scores.append(modelscore.scores[ind+holes-1].Score)
                let rate = modelscore.scores[ind+holes-1].Score - modelpar.getPar(hole: ind+holes)
                print(modelscore.scores[ind+holes-1].Score, modelpar.getPar(hole: ind+holes))
                switch rate {
                    case  ..<0:
                        rating.append("BI")
                    case  0:
                        rating.append("PA")
                    case  1:
                        rating.append("BO")
                    default:
                        rating.append("DO")
                }
            } else {
                scores.append(0)
                rating.append(" ")
            }
        }
        return (scores, rating)
    }
    func getcanScores(holes: Int) -> ([Int], [String]) {
        var scores: [Int] = []
        var rating: [String] = []
        for ind in 0...8 {
            if ind+holes <= modelscore.currentHole {
                scores.append(modelcanscore.canScores[ind+holes-1].MatchScore)
                let rate = modelcanscore.canScores[ind+holes-1].MatchScore - modelpar.getPar(hole: ind+holes)
                print(modelcanscore.canScores[ind+holes-1].MatchScore, modelpar.getPar(hole: ind+holes))
                switch rate {
                    case  ..<0:
                        rating.append("BI")
                    case  0:
                        rating.append("PA")
                    case  1:
                        rating.append("BO")
                    default:
                        rating.append("DO")
                }
            } else {
                scores.append(0)
                rating.append(" ")
            }
        }
        return (scores, rating)
    }
}
