//
//  ResultMessage.swift
//  CalculadoraESPOL
//
//  Created by Carlos Xavier Carvajal Villegas on 14/6/25.
//

import SwiftUI

struct ResultMessage: View {
    @Environment(CalculadoraVM.self) var vm
    @State private var isAnimating = false

    let result: Double
    var hasPassed: Bool {
        result >= 6
    }
    
    var body: some View {
        VStack(spacing: 24){
            //SF Icon
            ZStack {
                Circle()
                    .fill(.appPrimary.opacity(0.08))
                    .frame(width: 100, height: 100)
                Image(systemName: hasPassed ? "hands.and.sparkles.fill" : "hand.thumbsdown.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .rotationEffect(.degrees(isAnimating ? 10 : -10))
                    .animation(
                        .easeInOut(duration: 0.7).repeatForever(autoreverses: true),
                        value: isAnimating
                    )
            }
            .padding(.top, 20)
            
            // Result Message
            Text(hasPassed ? "Felicitaciones! 🥳" : "Lo sentimos mucho ☹️")
                .font(.title2.bold())
                .multilineTextAlignment(.center)
                .accessibilityAddTraits(.isHeader)
            Text(hasPassed ? "Aprobaste con \(String(format: "%.2f", result))" : "Reprobaste con \(String(format: "%.2f", result))")
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 8)
            
            //Button to close pop up
            Button {
                vm.totalScore = nil
            } label: {
                Label("Cerrar", systemImage: "xmark.circle.fill")
                    .font(.headline)
                    .padding(.horizontal, 28)
                    .padding(.vertical, 13)
                    .background(.appError)
                    .foregroundStyle(Color.red)
                    .clipShape(Capsule())
            }
            .accessibilityIdentifier("Close result message")
            .padding(.top, 6)

        }
        .padding()
        .frame(maxWidth: 350)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(.thinMaterial)
                .shadow(color: .black.opacity(0.16), radius: 10, x: 0, y: 8)
        )
        .onAppear { isAnimating = true }
        .accessibilityElement(children: .combine)
    }
}

#Preview("Has passed") {
    ResultMessage(result: 8.0)
        .environment(CalculadoraVM())
}

#Preview("Has not passed") {
    ResultMessage(result: 6.0)
        .environment(CalculadoraVM())
}
