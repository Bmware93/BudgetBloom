//
//  NavigationBarModifier.swift
//  SwiftDataExpensesTracker
//
//  Created by Benia Morgan-Ware on 1/6/25.
//

import SwiftUI
import UIKit

struct NavigationBarModifier: ViewModifier {

    init(backgroundColor: UIColor = .systemBackground, foregroundColor: UIColor = .accent, tintColor: UIColor?, withSeparator: Bool = true) {
        let appear = UINavigationBarAppearance()

        let atters: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: "Didot", size: 25)!
        ]

        appear.largeTitleTextAttributes = atters
        appear.titleTextAttributes = atters
        UINavigationBar.appearance().standardAppearance = appear
        UINavigationBar.appearance().compactAppearance = appear
        UINavigationBar.appearance().scrollEdgeAppearance = appear
        if let tintColor = tintColor {
                    UINavigationBar.appearance().tintColor = tintColor
            }
     }
    func body(content: Content) -> some View {
            content
        }
}

#Preview {
    NavigationStack {
        VStack {
            Text("Hello, World!")
            Button("Push Me") {
                
            }
        }
        .navigationBarTitle("Test Title")
    }
    .modifier(NavigationBarModifier(backgroundColor: .systemBackground, foregroundColor: .blue, tintColor: nil, withSeparator: false))
}
