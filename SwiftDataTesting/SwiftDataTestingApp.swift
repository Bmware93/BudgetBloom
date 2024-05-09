//
//  SwiftDataTestingApp.swift
//  SwiftDataTesting
//
//  Created by Benia Morgan-Ware on 11/28/23.
//

import SwiftUI
import SwiftData

@main
struct SwiftDataTestingApp: App {
    
//    init() {
//        let appear = UINavigationBarAppearance()
//
//        let atters: [NSAttributedString.Key: Any] = [
//            .font: UIFont(name: "AmericanTypewriter", size: 19)!
//        ]
//
//        appear.largeTitleTextAttributes = atters
//        appear.titleTextAttributes = atters
//        UINavigationBar.appearance().standardAppearance = appear
//        UINavigationBar.appearance().compactAppearance = appear
//        UINavigationBar.appearance().scrollEdgeAppearance = appear
//     }

    var body: some Scene {
        WindowGroup {
            AppTabView()
        }
        .modelContainer(for: [Expense.self])
    }
}
