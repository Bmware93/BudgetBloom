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
            Text(expense.value, format: .currency(code: "USD"))
        }
    }
}

#Preview {
    let preview = previewContainer([Expense.self])
    return ExpenseCellView(expense: Expense(name: "The Red Hook", date: .now, value: 12.80)).modelContainer(preview.container)
}
