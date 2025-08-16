//
//  Extensions.swift
//  CalculadoraESPOL
//
//  Created by Carlos Xavier Carvajal Villegas on 16/8/25.
//

import Foundation
extension SubjectDataSchemeV1.SubjectData {
    static var sampleSubject: SubjectDataSchemeV1.SubjectData {
        let subject = SubjectDataSchemeV1.SubjectData(
            name: "Programación Avanzada",
            theoricalPercentage: 70,
            firstPartialGrade: 78,
            secondPartialGrade: 85,
            practicalGrade: 92,
            improvementGrade: 90,
            totalGrade: 8.56
        )
        return subject
    }
}
