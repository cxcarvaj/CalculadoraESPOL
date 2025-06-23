//
//  Subject.swift
//  CalculadoraESPOL
//
//  Created by Carlos Xavier Carvajal Villegas on 14/6/25.
//

import Foundation
import SwiftData

@Model
final class Subject {
    @Attribute(.unique) var name: String
    var theoricalPercentage: Double
    var firstPartialGrade: Double
    var secondPartialGrade: Double
    var practicalGrade: Double
    var improvementGrade: Double
    
    init(name: String, theoricalPercentage: Double, firstPartialGrade: Double, secondPartialGrade: Double, practicalGrade: Double, improvementGrade: Double) {
        self.name = name
        self.theoricalPercentage = theoricalPercentage
        self.firstPartialGrade = firstPartialGrade
        self.secondPartialGrade = secondPartialGrade
        self.practicalGrade = practicalGrade
        self.improvementGrade = improvementGrade
    }
}
