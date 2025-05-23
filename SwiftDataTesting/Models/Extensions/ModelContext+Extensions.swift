//
//  File.swift
//  SwiftDataExpensesTracker
//
//  Created by Benia Morgan-Ware on 3/4/25.
//

import Foundation
import SwiftData

@MainActor
 func createModelContext() -> ModelContext? {
    do {
        let container = try ModelContainer(for: Expense.self)
        return container.mainContext
    } catch {
        print("Failed to create SwiftData container: \(error)")
        return nil
    }
}
