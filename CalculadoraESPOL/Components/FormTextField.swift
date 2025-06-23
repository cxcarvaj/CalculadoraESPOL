//
//  FormTextField.swift
//  CalculadoraESPOL
//
//  Created by Carlos Xavier Carvajal Villegas on 14/6/25.
//


import SwiftUI

struct FormTextField: View {
    let title: String
    let placeholder: String
    let icon: String?
    
    @Binding var text: String
    let keyboardType: UIKeyboardType
    let isOptional: Bool
    let maxValue: Double = 0
    let minValue: Double = 100
    
    @State private var showError: Bool = false
    @State private var errorMessage: String = ""
    
    init(
        title: String,
        placeholder: String,
        icon: String? = nil,
        text: Binding<String>,
        keyboardType: UIKeyboardType = .decimalPad,
        isOptional: Bool = false,
    ) {
        self.title = title
        self.placeholder = placeholder
        self.icon = icon
        self._text = text
        self.keyboardType = keyboardType
        self.isOptional = isOptional
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundStyle(.primary)
                
                if isOptional {
                    Text("(opcional)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            
            HStack(spacing: 12) {
                if let icon = icon {
                    Image(systemName: icon)
                        .foregroundStyle(showError ? .red : .blue)
                        .font(.system(size: 16, weight: .medium))
                        .frame(width: 20)
                }
                
                TextField(placeholder, text: $text)
                    .keyboardType(keyboardType)
                    .autocorrectionDisabled()
                    .font(.body)
                    .onChange(of: text) { _, newValue in
                        if newValue.isEmpty || keyboardType != .decimalPad {
                            errorMessage = ""
                            showError = false
                            return
                        }
                        validateInput(newValue)
                    }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemGray6))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(
                                showError ? Color.red.opacity(0.6) :
                                (text.isEmpty ? Color.clear : Color.blue.opacity(0.3)),
                                lineWidth: showError ? 2 : 1
                            )
                    )
            )
            
            if showError && !errorMessage.isEmpty {
                HStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundStyle(.red)
                        .font(.caption)
                    
                    Text(errorMessage)
                        .font(.caption)
                        .foregroundStyle(.red)
                }
                .padding(.horizontal, 4)
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .animation(.easeInOut(duration: 0.2), value: showError)
    }
    
    private func validateInput(_ input: String) {
        if input.isEmpty {
            if isOptional {
                showError = false
                errorMessage = ""
            } else {
                showError = true
                errorMessage = "Este campo es obligatorio"
            }
            return
        }
        
        guard let value = Double(input.replacingOccurrences(of: ",", with: ".")) else {
            showError = true
            errorMessage = "Ingrese un número válido"
            return
        }
        
        if value == 0 {
            showError = false
            errorMessage = ""
            return
        }
        
        if value > minValue || value <= maxValue {
            showError = true
            errorMessage = "El valor debe ser mayor o igual a \(Int(minValue))"
            return
        }
        
        showError = false
        errorMessage = ""
    }
}

#Preview {
    @Previewable @State var text = "86.9"
    
    FormTextField(title: "Calificación",
                  placeholder: "Escribe tu calificación",
                  icon: "graduationcap.fill",
                  text: $text)
}
