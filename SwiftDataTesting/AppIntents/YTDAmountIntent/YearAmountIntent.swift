//
//  YearAmountIntent.swift
//  SwiftDataExpensesTracker
//
//  Created by Benia Morgan-Ware on 6/3/25.
//

import Foundation
import AppIntents
import SwiftData

struct YearAmountIntent: AppIntent {
    static var title: LocalizedStringResource = "YTD Spending"
    static var description: IntentDescription = "Check your year-to-date spending"
    
    func perform() async throws -> some IntentResult {
        let modelContainer = try ModelContainer(for: Expense.self)
        
        
        
        
        return .result(
            value: "",
            dialog: "Hello World"
        )

    }
}
