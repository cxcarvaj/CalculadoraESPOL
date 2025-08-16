//
//  CalculadoraVM.swift
//  CalculadoraESPOL
//
//  Created by Carlos Xavier Carvajal Villegas on 14/6/25.
//

import Foundation
import SwiftData

@Observable
final class CalculadoraVM {
    
    var selectedSubjectName: String?
    var subjectName: String = ""
    var selectedSubject: SubjectDataSchemeV1.SubjectData?
        
    var theoricalPercentage: String = ""
    var firstPartialGrade: String = ""
    var secondPartialGrade: String = ""
    var practicalGrade: String = ""
    var improvementGrade: String = ""
    var totalScore: Double?
    var areValuesValid: Bool {
        !firstPartialGrade.isEmpty &&
        !secondPartialGrade.isEmpty
    }
    
    func loadSubjectData(_ subject: SubjectDataSchemeV1.SubjectData) {
        selectedSubject = subject
        selectedSubjectName = subject.name
        subjectName = subject.name
        
        theoricalPercentage = String(subject.theoricalPercentage)
        firstPartialGrade = String(subject.firstPartialGrade)
        secondPartialGrade = String(subject.secondPartialGrade)
        practicalGrade = String(subject.practicalGrade)
        improvementGrade = subject.improvementGrade > 0 ? String(subject.improvementGrade) : ""
    }

    func getScore() {
        guard let firstPartialValue = Double(firstPartialGrade),
              let secondPartialValue = Double(secondPartialGrade)
        else { return }
        
        let theoricalValue = Double(theoricalPercentage) ?? 100
        let practicalValue = Double(practicalGrade) ?? 100
        let improvementValue = improvementGrade.isEmpty ? nil : Double(improvementGrade)
        
        totalScore = calculateScore(
            firstPartial: firstPartialValue,
            secondPartial: secondPartialValue,
            theoretical: theoricalValue,
            practical: practicalValue,
            improvement: improvementValue
        )
    }
    
    func calculateScore(
        firstPartial: Double,
        secondPartial: Double,
        theoretical: Double,
        practical: Double,
        improvement: Double?
    ) -> Double {
        let theoricalPercent = theoretical / 100
        let practicalPercent = (100 - theoretical) / 100
        
        let practicalComponent = practical * practicalPercent
        var theoricalComponent: Double
        
        if let improvementValue = improvement {
            let lowestGrade = min(firstPartial, secondPartial)
            
            if improvementValue > lowestGrade {
                let betterGrade = max(firstPartial, secondPartial)
                theoricalComponent = ((betterGrade + improvementValue) / 2) * theoricalPercent
            } else {
                theoricalComponent = ((firstPartial + secondPartial) / 2) * theoricalPercent
            }
        } else {
            theoricalComponent = ((firstPartial + secondPartial) / 2) * theoricalPercent
        }
        
        return (practicalComponent + theoricalComponent) / 10
    }
    
    func clearFields() {
        selectedSubject = nil
        selectedSubjectName = nil
        theoricalPercentage = ""
        firstPartialGrade = ""
        secondPartialGrade = ""
        practicalGrade = ""
        improvementGrade = ""
        subjectName = ""
        print("🧹 Campos limpiados")
    }
    
    private func isSubjectNameUnique(_ name: String, using modelContext: ModelContext) -> Bool {
        if name == selectedSubjectName {
            return true
        }
        
        let fetchDescriptor = FetchDescriptor<SubjectDataSchemeV1.SubjectData>(
            predicate: #Predicate<SubjectDataSchemeV1.SubjectData> { subject in
                subject.name == name
            }
        )
        
        do {
            let existingSubjects = try modelContext.fetch(fetchDescriptor)
            return existingSubjects.isEmpty
        } catch {
            print("❌ Error verificando nombre único: \(error)")
            return false
        }
    }
    
    func saveSubject(using modelContext: ModelContext) {
        guard let theoricalValue = Double(theoricalPercentage),
              let practicalValue = Double(practicalGrade),
              let firstPartialValue = Double(firstPartialGrade),
              let secondPartialValue = Double(secondPartialGrade) else {
            print("❌ Error: Valores inválidos")
            return
        }
        
        let improvementValue = Double(improvementGrade) ?? 0
        
        if subjectName != selectedSubjectName && !isSubjectNameUnique(subjectName, using: modelContext) {
            print("❌ Error: Ya existe una materia con el nombre '\(subjectName)'")
            return
        }
        
        let totalGrade = calculateScore(
            firstPartial: firstPartialValue,
            secondPartial: secondPartialValue,
            theoretical: theoricalValue,
            practical: practicalValue,
            improvement: improvementValue
        )
        
        if subjectName == selectedSubjectName {
            updateExistingSubject(
                using: modelContext,
                theoricalValue: theoricalValue,
                practicalValue: practicalValue,
                firstPartialValue: firstPartialValue,
                secondPartialValue: secondPartialValue,
                improvementValue: improvementValue,
                totalGrade: totalGrade
            )
        } else {
            createNewSubject(
                using: modelContext,
                theoricalValue: theoricalValue,
                practicalValue: practicalValue,
                firstPartialValue: firstPartialValue,
                secondPartialValue: secondPartialValue,
                improvementValue: improvementValue,
                totalGrade: totalGrade
            )
        }
    }

    private func updateExistingSubject(
        using modelContext: ModelContext,
        theoricalValue: Double,
        practicalValue: Double,
        firstPartialValue: Double,
        secondPartialValue: Double,
        improvementValue: Double,
        totalGrade: Double
    ) {
        let nameToSearch = subjectName
        
        let fetchDescriptor = FetchDescriptor<SubjectDataSchemeV1.SubjectData>(
            predicate: #Predicate<SubjectDataSchemeV1.SubjectData> { subject in
                subject.name == nameToSearch
            }
        )
        
        do {
            let existingSubjects = try modelContext.fetch(fetchDescriptor)
            
            if let existingSubject = existingSubjects.first {
                existingSubject.theoricalPercentage = theoricalValue
                existingSubject.firstPartialGrade = firstPartialValue
                existingSubject.secondPartialGrade = secondPartialValue
                existingSubject.practicalGrade = practicalValue
                existingSubject.improvementGrade = improvementValue
                
                try modelContext.save()
                print("✅ Materia '\(nameToSearch)' actualizada correctamente")
                
                selectedSubject = existingSubject
                
            } else {
                print("⚠️ No se encontró la materia para actualizar, creando nueva...")
                createNewSubject(
                    using: modelContext,
                    theoricalValue: theoricalValue,
                    practicalValue: practicalValue,
                    firstPartialValue: firstPartialValue,
                    secondPartialValue: secondPartialValue,
                    improvementValue: improvementValue,
                    totalGrade: totalGrade
                )
            }
            
        } catch {
            print("❌ Error buscando materia existente: \(error)")
        }
    }

    private func createNewSubject(
        using modelContext: ModelContext,
        theoricalValue: Double,
        practicalValue: Double,
        firstPartialValue: Double,
        secondPartialValue: Double,
        improvementValue: Double,
        totalGrade: Double,
    ) {
        let newSubject = SubjectDataSchemeV1.SubjectData(
            name: subjectName,
            theoricalPercentage: theoricalValue,
            firstPartialGrade: firstPartialValue,
            secondPartialGrade: secondPartialValue,
            practicalGrade: practicalValue,
            improvementGrade: improvementValue,
            totalGrade: totalGrade
        )
        
        modelContext.insert(newSubject)
        
        do {
            try modelContext.save()
            print("✅ Nueva materia '\(subjectName)' guardada correctamente")
            
            // ✅ Actualizar estado local
            selectedSubject = newSubject
            selectedSubjectName = subjectName
            
        } catch {
            print("❌ Error guardando nueva materia: \(error)")
        }
    }

}
