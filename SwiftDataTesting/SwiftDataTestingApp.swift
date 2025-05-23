//
//  SwiftDataTestingApp.swift
//  SwiftDataTesting
//
//  Created by Benia Morgan-Ware on 11/28/23.
//

import SwiftUI
import SwiftData
import UIKit
import AppIntents

@main
struct SwiftDataTestingApp: App {

    var body: some Scene {
        WindowGroup {
            AppTabView()
        }
        .modelContainer(for: [Expense.self])
    }
}
