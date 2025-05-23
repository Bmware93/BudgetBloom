//
//  CheckTodaysSpending.swift
//  SwiftDataExpensesTracker
//
//  Created by Benia Morgan-Ware on 3/4/25.
//

import SwiftUI
import AppIntents
import SwiftData

struct GetAmountSpentIntent: AppIntent {
    static var title: LocalizedStringResource = "Check Today's Spending"
    static var description = IntentDescription("Check how much you've spent today")
    
    @MainActor
      func perform() async throws -> some IntentResult & ProvidesDialog {
          let modelContainer = try ModelContainer(for: Expense.self)

          let currentDate: Date = .now
          let expenseData = getDailyExpenseSum(modelContext: modelContainer.mainContext, for: currentDate)

          guard let firstEntry = expenseData.elements.first else {
                      return .result(dialog: "You have not spent anything today.")
                  }

          let totalSum = currencyFormat(value: firstEntry.value.sum)

          return .result(dialog: "You have spent a total of \(totalSum) today.")
      }
}
