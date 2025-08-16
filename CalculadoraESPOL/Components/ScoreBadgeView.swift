//
//  ScoreBadgeView.swift
//  CalculadoraESPOL
//
//  Created by Carlos Xavier Carvajal Villegas on 16/8/25.
//

import SwiftUI

struct ScoreBadgeView: View {
    let score: Double
    
    var scoreColor: Color {
        switch score {
        case ..<5.0:
            return .red
        case 5.0..<7.0:
            return .orange
        case 7.0..<9.0:
            return .blue
        default:
            return .green
        }
    }
    
    var body: some View {
        Text(String(format: "%.2f", score))
            .font(.system(.title3, design: .rounded, weight: .bold))
            .padding(8)
            .background(scoreColor.opacity(0.2))
            .foregroundStyle(scoreColor)
            .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

#Preview {
    ScoreBadgeView(score: 9)
}
