//
//  SampleData.swift
//  CalculadoraESPOL
//
//  Created by Carlos Xavier Carvajal Villegas on 14/6/25.
//

import Foundation
import SwiftData
import SwiftUI

struct SampleData: PreviewModifier {
    static func makeSharedContext() async throws -> ModelContainer {
        let configuration = ModelConfiguration(for: Subject.self, isStoredInMemoryOnly: true)
        
        let container = try ModelContainer(for: Subject.self, configurations: configuration)
        
        let calculadoraEspolTestContainer = CalculadoraEspolPreviewContainer(context: container.mainContext)
        
        try calculadoraEspolTestContainer.loadSubjects()
        
        return container
    }
    
    func body(content: Content, context: ModelContainer) -> some View {
        content.modelContainer(context)
    }
}

extension PreviewTrait where T == Preview.ViewTraits {
    @MainActor static var sampleData: Self = .modifier(SampleData())
}
