//
//  SubjectDetailView.swift
//  CalculadoraESPOL
//
//  Created by Carlos Xavier Carvajal Villegas on 16/8/25.
//

import SwiftUI

struct SubjectDetailView: View {
    let subject: SubjectDataSchemeV1.SubjectData
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                VStack(alignment: .center, spacing: 8) {
                    Text(subject.name)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                    
                    ScoreBadgeView(score: subject.totalGrade)
                        .scaleEffect(1.2)
                        .padding()
                    
                    Group {
                        DetailSectionView(title: "Componente Teórico (\(subject.theoricalPercentage)%)") {
                            DetailRowView(title: "Primer Parcial", value: "\(subject.firstPartialGrade)")
                            DetailRowView(title: "Segundo Parcial", value: "\(subject.secondPartialGrade)")
                            if subject.improvementGrade > 0 {
                                DetailRowView(title: "Mejoramiento", value: "\(subject.improvementGrade)")
                            }
                        }
                        
                        DetailSectionView(title: "Componente Práctico (\(100 - subject.theoricalPercentage)%)") {
                            DetailRowView(title: "Calificación", value: "\(subject.practicalGrade)")
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.gray.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .padding()
        }
        .navigationTitle("Detalles de la Materia")
//        .navigationBarModifier(backgroundColor: .appNavigationBar, foregroundColor: .white, withSeparator: true)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct DetailSectionView<Content: View>: View {
    let title: String
    @ViewBuilder let content: () -> Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .padding(.bottom, 4)
            
            content()
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct DetailRowView: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .foregroundStyle(.secondary)
            Spacer()
            Text(value)
                .fontWeight(.medium)
        }
        .padding(.vertical, 4)
    }
}

#Preview(traits: .sampleData) {
    SubjectDetailView(subject: .sampleSubject)
}

