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
    var selectedSubject: Subject?
        
    var theoricalPercentage: String = ""
    var firstPartialGrade: String = ""
    var secondPartialGrade: String = ""
    var practicalGrade: String = ""
    var improvementGrade: String = ""
    var totalScore: Double?
    var areValuesValid: Bool {
        !theoricalPercentage.isEmpty &&
        !firstPartialGrade.isEmpty &&
        !secondPartialGrade.isEmpty &&
        !practicalGrade.isEmpty
    }
    
    func loadSubjectData(_ subject: Subject) {
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
        guard let theoricalValue = Double(theoricalPercentage),
              let practicalValue = Double(practicalGrade),
              let firstPartialValue = Double(firstPartialGrade),
              let secondPartialValue = Double(secondPartialGrade)
        else { return }
        
        let practicalPercentage = (100 - theoricalValue) / 100
        let practicalGrade = practicalValue * practicalPercentage
        let theoricalPercentage = theoricalValue / 100
        let theoricalGrade = ((firstPartialValue + secondPartialValue) / 2) * theoricalPercentage
        
        totalScore = (practicalGrade + theoricalGrade) / 10
        
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
        
        let fetchDescriptor = FetchDescriptor<Subject>(
            predicate: #Predicate<Subject> { subject in
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
        
        if subjectName == selectedSubjectName {
            updateExistingSubject(
                using: modelContext,
                theoricalValue: theoricalValue,
                practicalValue: practicalValue,
                firstPartialValue: firstPartialValue,
                secondPartialValue: secondPartialValue,
                improvementValue: improvementValue
            )
        } else {
            createNewSubject(
                using: modelContext,
                theoricalValue: theoricalValue,
                practicalValue: practicalValue,
                firstPartialValue: firstPartialValue,
                secondPartialValue: secondPartialValue,
                improvementValue: improvementValue
            )
        }
    }

    private func updateExistingSubject(
        using modelContext: ModelContext,
        theoricalValue: Double,
        practicalValue: Double,
        firstPartialValue: Double,
        secondPartialValue: Double,
        improvementValue: Double
    ) {
        let nameToSearch = subjectName
        
        let fetchDescriptor = FetchDescriptor<Subject>(
            predicate: #Predicate<Subject> { subject in
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
                    improvementValue: improvementValue
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
        improvementValue: Double
    ) {
        let newSubject = Subject(
            name: subjectName,
            theoricalPercentage: theoricalValue,
            firstPartialGrade: firstPartialValue,
            secondPartialGrade: secondPartialValue,
            practicalGrade: practicalValue,
            improvementGrade: improvementValue
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
