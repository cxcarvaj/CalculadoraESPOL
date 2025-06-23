//
//  CalculadoraESPOLApp.swift
//  CalculadoraESPOL
//
//  Created by Carlos Xavier Carvajal Villegas on 14/6/25.
//

import SwiftUI

@main
struct CalculadoraESPOLApp: App {
    @State private var vm: CalculadoraVM = CalculadoraVM()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(vm)
                .modelContainer(for: SubjectDataSchemeV1.SubjectData.self)
        }
    }
}
