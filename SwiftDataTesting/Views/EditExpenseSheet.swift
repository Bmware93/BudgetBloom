//
//  EditExpenseSheet.swift
//  SwiftDataExpensesTracker
//
//  Created by Benia Morgan-Ware on 1/4/24.
//

import SwiftUI
import SwiftData

struct EditExpenseSheet: View {
    @Environment(\.dismiss) private var dismiss
    
    @Bindable var expense: Expense
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Expense Name", text: $expense.name)
                DatePicker("Date", selection: $expense.date, displayedComponents: .date)
                TextField("Value", value: $expense.amount, format: .currency(code: "USD"))
                    .keyboardType(.decimalPad)
                Picker("Category", selection: $expense.category){
                    ForEach(SpendingCategory.allCases, id: \.self) { option in
                        Text(option.rawValue)
                    }
                }
                
            }
            .navigationTitle("Update Expense")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done"){ dismiss() }
                }
              
            }

        }
    }
}

#Preview {
    let preview = previewContainer([Expense.self])
    return EditExpenseSheet(expense: Expense(name: "", date: .now, amount: 0, category: .clothing)).modelContainer(preview.container)
}
