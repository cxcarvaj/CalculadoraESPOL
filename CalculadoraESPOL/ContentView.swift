//
//  ContentView.swift
//  CalculadoraESPOL
//
//  Created by Carlos Xavier Carvajal Villegas on 14/6/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(CalculadoraVM.self) var vm
    @Environment(\.accessibilityReduceMotion) var motion

    var body: some View {
        TabView {
            Tab("Calculadora",
                systemImage: "compass.drawing") {
                CalculadoraView()
            }
            
            Tab("Historial",
                systemImage: "pencil.and.list.clipboard") {
                HistorialView()
            }
        }
        .backgroundOverlay(vm.totalScore == nil)
        .overlay {
            ResultMessage(result: vm.totalScore ?? 0.0)
                .opacity(vm.totalScore != nil ? 1 : 0)
                .offset(y: vm.totalScore == nil ? motion ? 0 : 500 : 0)
        }
        .animation(.bouncy, value: vm.totalScore)
    }
}

#Preview(traits: .sampleData) {
    ContentView()
        .environment(CalculadoraVM())
}
