//
//  SubjectsPicker.swift
//  CalculadoraESPOL
//
//  Created by Carlos Xavier Carvajal Villegas on 14/6/25.
//

import SwiftUI
import SwiftData

struct SubjectsPicker: View {
    @Environment(CalculadoraVM.self) var vm
    @Query private var subjects: [Subject]

    var body: some View {
        @Bindable var vm = vm
        if subjects.count > 0 {
            VStack(spacing: 20) {
                HStack {
                    Text("Materias guardadas:")
                        .font(.subheadline)
                    Picker("Selecciona una materia", selection: $vm.selectedSubjectName) {
                        Text("Elige una materia").tag(String?.none)
                        ForEach(subjects, id: \.name) {subject in
                            Text(subject.name).tag(subject.name)
                        }
                    }
                    .onChange(of: vm.selectedSubjectName) { oldValue, newSubjectName in
                        if let subject = subjects.first(where: { $0.name == newSubjectName }) {
                            vm.loadSubjectData(subject)
                        } else {
                            vm.clearFields()
                        }
                    }
                }
                .pickerStyle(.menu)
                .frame(maxWidth: .infinity, alignment: .center)
            }
            .padding()
        } else {
            Text("No tienes registros guardados de materias 💾")
                .padding()
                .multilineTextAlignment(.center)
        }
    }
}

#Preview(traits: .sampleData) {
    SubjectsPicker()
        .environment(CalculadoraVM())
}
