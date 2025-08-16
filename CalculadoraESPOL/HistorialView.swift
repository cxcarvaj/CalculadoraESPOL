//
//  HistorialView.swift
//  CalculadoraESPOL
//
//  Created by Carlos Xavier Carvajal Villegas on 16/8/25.
//

import SwiftUI
import SwiftData

struct HistorialView: View {
    @State private var searchText = ""
    @Environment(\.modelContext) private var modelContext
    @Query private var subjects: [SubjectDataSchemeV1.SubjectData]
    @State private var showingDeleteAlert = false
    @State private var indexSetToDelete: IndexSet?
    
    var filteredSubjects: [SubjectDataSchemeV1.SubjectData] {
        return searchText.isEmpty ?
        subjects :
        subjects.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(UIColor.systemBackground)
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    Spacer(minLength: 1)
                    
                    if filteredSubjects.isEmpty {
                        ContentUnavailableView {
                            Label("No hay materias guardadas", systemImage: "book.closed")
                        } description: {
                            if searchText.isEmpty {
                                Text("Agrega materias para verlas en el historial")
                            } else {
                                Text("No hay resultados para '\(searchText)'")
                            }
                        } actions: {
                            Button {
                                searchText = ""
                            } label: {
                                Label("Limpiar búsqueda", systemImage: "xmark.circle")
                            }
                            .disabled(searchText.isEmpty)
                        }
                        .padding(.top)
                    } else {
                        List {
                            ForEach(filteredSubjects, id: \.id) { subject in
                                NavigationLink(destination: SubjectDetailView(subject: subject)) {
                                    HStack {
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(subject.name)
                                                .font(.headline)
                                        }
                                    }
                                    .padding(.vertical, 4)
                                }
                            }
                            .onDelete { IndexSet in
                                indexSetToDelete = IndexSet
                                showingDeleteAlert = true
                            }
                        }
                        .listStyle(.insetGrouped)
                    }
                }
            }
            .navigationTitle("Historial de Materias")
            .navigationBarModifier(backgroundColor: .appNavigationBar, foregroundColor: .white, withSeparator: true)
            .navigationBarTitleDisplayMode(.large)
            .searchable(
                text: $searchText,
                prompt: "Buscar por nombre de materia",
            )
            .onAppear {
                // Cambiar el color del texto en el SearchBar
                UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).tintColor = .label
                UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = .systemBackground
                
                // Cambiar el color del placeholder
                UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).attributedPlaceholder = NSAttributedString(
                    string: "Buscar por nombre de materia",
                    attributes: [NSAttributedString.Key.foregroundColor: UIColor.placeholderText]
                )
            }
            .alert("¿Eliminar materia?", isPresented: $showingDeleteAlert) {
                Button(role: .cancel) {
                    indexSetToDelete = nil
                } label: {
                    Text("Cancelar")
                }
                
                Button(role: .destructive) {
                    if let indexSet = indexSetToDelete {
                        deleteItems(at: indexSet)
                    }
                } label: {
                    Text("Eliminar")
                }
                
            } message: {
                Text("¿Estás seguro que deseas eliminar esta materia? Esta acción no se puede deshacer.")
            }
        }
    }
    
    private func deleteItems(at offsets: IndexSet) {
        for index in offsets {
            if index < filteredSubjects.count {
                let subject = filteredSubjects[index]
                modelContext.delete(subject)
            }
        }
        try? modelContext.save()
        indexSetToDelete = nil
    }
}
    
#Preview(traits: .sampleData) {
    HistorialView()
}
