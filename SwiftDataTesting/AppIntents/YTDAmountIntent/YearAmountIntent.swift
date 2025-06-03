//
//  YearAmountIntent.swift
//  SwiftDataExpensesTracker
//
//  Created by Benia Morgan-Ware on 6/3/25.
//

import Foundation
import AppIntents

struct YearAmountIntent: AppIntent {
    static var title: LocalizedStringResource = "YTD Spending"
    static var description: IntentDescription = "Check your year-to-date spending"
    
    func perform() async throws -> some IntentResult {
        
        
        
        
        return .result(
            value: "",
            dialog: "Hello World"
        )

    }
}
