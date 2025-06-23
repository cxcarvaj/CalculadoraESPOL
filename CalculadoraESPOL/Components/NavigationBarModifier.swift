//
//  NavigationBarModifier.swift
//  CalculadoraESPOL
//
//  Created by Carlos Xavier Carvajal Villegas on 21/6/25.
//
import SwiftUI
import UIKit

struct NavigationBarModifier: ViewModifier {
    init(backgroundColor: UIColor = .systemBackground, foregroundColor: UIColor = .blue, tintColor: UIColor? = nil, withSeparator: Bool = true) {
        
        let navBarAppearance = UINavigationBarAppearance()
        
        navBarAppearance.titleTextAttributes = [.foregroundColor: foregroundColor]
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: foregroundColor]
        navBarAppearance.backgroundColor = backgroundColor
        
        if withSeparator {
            navBarAppearance.shadowColor = .clear
        }
        
        UINavigationBar.appearance().standardAppearance = navBarAppearance
        UINavigationBar.appearance().compactAppearance = navBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
        
        if let tintColor = tintColor {
            UINavigationBar.appearance().tintColor = tintColor
        }
    }
    func body(content: Content) -> some View {
        content
    }
}

extension View {
    func navigationBarModifier(backgroundColor: UIColor = .systemBackground, foregroundColor: UIColor = .label, tintColor: UIColor? = nil, withSeparator: Bool) -> some View {
        
        self.modifier(NavigationBarModifier(backgroundColor: backgroundColor, foregroundColor: foregroundColor, tintColor: tintColor, withSeparator: withSeparator))
    }
}

#Preview {
    NavigationStack {
        Text("My Text Text")
            .navigationTitle("Test title")
            .navigationBarModifier(backgroundColor: .systemBackground, foregroundColor: .systemBlue, tintColor: nil, withSeparator: true)
        
            
    }
}
