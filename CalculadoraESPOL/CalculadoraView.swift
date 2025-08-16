//
//  CalculadoraView.swift
//  CalculadoraESPOL
//
//  Created by Carlos Xavier Carvajal Villegas on 14/6/25.
//

import SwiftUI

struct CalculadoraView: View {
    @Environment(CalculadoraVM.self) var vm
    @Environment(\.modelContext) private var context
    
    @FocusState private var focusedField: FocusedField?
    
    var body: some View {
        @Bindable var vm = vm
        NavigationStack {
            ScrollView {
                VStack(alignment: .center, spacing: 20) {
                    
                    SubjectsPicker()
                    
                    FormTextField(
                        title: "Nombre de la materia",
                        placeholder: "Ej: Cálculo de Varias Variables",
                        text: $vm.subjectName,
                        keyboardType: .alphabet
                    )
                    .focused($focusedField, equals: .subjectName)
                    
                    FormTextField(
                        title: "Porcentaje teórico (%)",
                        placeholder: "Ej: 70",
                        text: $vm.theoricalPercentage,
                        keyboardType: .decimalPad
                    )
                    .focused($focusedField, equals: .theorical)
                    
                    FormTextField(
                        title: "Primer parcial",
                        placeholder: "Nota sobre 100",
                        text: $vm.firstPartialGrade,
                        keyboardType: .decimalPad
                    )
                    .focused($focusedField, equals: .firstPartial)
                    
                    FormTextField(
                        title: "Segundo parcial",
                        placeholder: "Nota sobre 100",
                        text: $vm.secondPartialGrade,
                        keyboardType: .decimalPad
                    )
                    .focused($focusedField, equals: .secondPartial)
                    
                    FormTextField(
                        title: "Nota práctica",
                        placeholder: "Nota sobre 100",
                        text: $vm.practicalGrade,
                        keyboardType: .decimalPad
                    )
                    .focused($focusedField, equals: .practical)
                    
                    FormTextField(
                        title: "Mejoramiento",
                        placeholder: "Nota sobre 100 (opcional)",
                        text: $vm.improvementGrade,
                        keyboardType: .decimalPad,
                        isOptional: true
                    )
                    .focused($focusedField, equals: .improvement)
                    
//                    Spacer()
                    
                    HStack(spacing: 10) {
                        Button {
                            vm.getScore()
                            focusedField = nil
                        } label: {
                            HStack {
                                Image(systemName: "function")
                                Text("Calcular")
                            }
                            .font(.callout)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
//                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(vm.areValuesValid ? .appNavigationBar : Color.accentColor)
                            )
                        }
                        .disabled(!vm.areValuesValid)
                        
                        Button {
                            vm.saveSubject(using: context)
                        } label: {
                            HStack {
                                Image(systemName: vm.subjectName == vm.selectedSubjectName ? "arrow.clockwise" : "plus")
                                Text(vm.subjectName == vm.selectedSubjectName ? "Actualizar materia" : "Guardar materia")
                            }
                            .font(.callout)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
//                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(vm.areValuesValid ? .appNavigationBar : Color.accentColor)
                            )
                        }
                        .disabled(!vm.areValuesValid)
                        
                    }
                    .padding(.vertical)
                }
                .padding(.horizontal)
                .toolbar {
                    ToolbarItemGroup(placement: .keyboard) {
                        Button {
                            moveToPreviousField()
                        } label: {
                            Label("Anterior", systemImage: "chevron.up")
                        }
                        .disabled(focusedField == FocusedField.allCases.first)

//                        Button("Anterior", systemImage: "chevron.up") {
//                            moveToPreviousField()
//                        }
//                        .disabled(focusedField == FocusedField.allCases.first)
                        
                        Button {
                            moveToNextField()
                        } label: {
                            Label("Siguiente", systemImage: "chevron.down")
                        }
                        .disabled(focusedField == FocusedField.allCases.last)
                        
//                        Button("Siguiente", systemImage: "chevron.down") {
//                            moveToNextField()
//                        }
//                        .disabled(focusedField == FocusedField.allCases.last)
                        
                        Spacer()
                        
                        Button("Listo") {
                            focusedField = nil
                        }
                        .font(.headline)
                        .foregroundStyle(.blue)
                    }
                }
//                .toolbar {
//                    ToolbarItem(placement: .cancellationAction) {
//                        Text("Calculadora")
//                            .foregroundColor(.white)
//                            .fontWeight(.bold)
//                            .font(.title3)
//                    }
//                }
//                .toolbarBackground(.appNavigationBar, for: .navigationBar)
//                .toolbarBackground(.visible, for: .automatic)
                .navigationTitle("Calculadora ESPOL")
                .navigationBarModifier(backgroundColor: .appNavigationBar, foregroundColor: .white, withSeparator: true)
//                .navigationBarTitleDisplayMode(.inline)
                .onTapGesture {
                    focusedField = nil
                }
            }
        }
    }
    private func moveToNextField() {
        guard let currentField = focusedField,
              let currentIndex = FocusedField.allCases.firstIndex(of: currentField),
              currentIndex < FocusedField.allCases.count - 1 else { return }
        
        focusedField = FocusedField.allCases[currentIndex + 1]
    }
        
    private func moveToPreviousField() {
        guard let currentField = focusedField,
              let currentIndex = FocusedField.allCases.firstIndex(of: currentField),
              currentIndex > 0 else { return }
        
        focusedField = FocusedField.allCases[currentIndex - 1]
    }
}

#Preview(traits: .sampleData) {
    CalculadoraView()
        .environment(CalculadoraVM())
}
