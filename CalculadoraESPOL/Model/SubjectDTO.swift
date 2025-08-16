//
//  SubjectDTO.swift
//  CalculadoraESPOL
//
//  Created by Carlos Xavier Carvajal Villegas on 14/6/25.
//

import Foundation

struct SubjectDTO: Codable {
    let name: String
    let theoricalPercentage: Double
    let firstPartialGrade: Double
    let secondPartialGrade: Double
    let practicalGrade: Double
    let improvementGrade: Double
    let totalGrade: Double
}

struct SubjectResponseDTO: Codable {
    let subjects: [SubjectDTO]
}
