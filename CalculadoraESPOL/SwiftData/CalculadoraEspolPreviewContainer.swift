//
//  CalculadoraEspolPreviewContainer.swift
//  CalculadoraESPOL
//
//  Created by Carlos Xavier Carvajal Villegas on 14/6/25.
//

import Foundation
import SwiftData

final class CalculadoraEspolPreviewContainer {
    
    var urlSubjects: URL {
        Bundle.main.url(forResource: "subjects", withExtension: "json")!
    }
    
    let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }
    
    func loadSubjects() throws {
        let data = try Data(contentsOf: urlSubjects)
        let subjectDTO = try JSONDecoder().decode(SubjectResponseDTO.self, from: data).subjects
        
        subjectDTO.map {
            SubjectDataSchemeV1.SubjectData(name: $0.name, theoricalPercentage: $0.theoricalPercentage, firstPartialGrade: $0.firstPartialGrade, secondPartialGrade: $0.secondPartialGrade, practicalGrade: $0.practicalGrade, improvementGrade: $0.improvementGrade)
        }.forEach { context.insert($0) }
        
    }
    
    func saveSubjectData(_ subject: SubjectDTO) throws {
        print("Guardando....")
        let subject = SubjectDataSchemeV1.SubjectData(name: subject.name,
                              theoricalPercentage: subject.theoricalPercentage,
                              firstPartialGrade: subject.firstPartialGrade,
                              secondPartialGrade: subject.secondPartialGrade,
                              practicalGrade: subject.practicalGrade,
                              improvementGrade: subject.improvementGrade)
        
        context.insert(subject)
        try context.save()
    }
}
