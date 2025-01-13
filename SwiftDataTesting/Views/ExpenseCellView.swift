//
//  ExpenseCellView.swift
//  SwiftDataExpensesTracker
//
//  Created by Benia Morgan-Ware on 1/4/24.
//

import SwiftUI
import SwiftData

struct ExpenseCellView: View {
    
    let expense: Expense
    
    var body: some View {
        HStack {
            Text(expense.date, format: .dateTime.month(.abbreviated).day())
                .frame(width: 70, alignment: .leading)
            Text(expense.name)
            Spacer()
            Text(currencyFormat(value:expense.amount))
        }
    }
}

#Preview {
    let preview = previewContainer([Expense.self])
    ExpenseCellView(expense: Expense(name: "The Red Hook", date: .now, amount: 12.80, category: .food, expenseDescription: "")).modelContainer(preview.container)
}
