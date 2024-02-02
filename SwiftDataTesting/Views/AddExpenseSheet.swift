//
//  AddExpenseSheet.swift
//  SwiftDataExpensesTracker
//
//  Created by Benia Morgan-Ware on 1/4/24.
//

import SwiftUI
import SwiftData

struct AddExpenseSheet: View {
    
    //Inserting the model context into the expense sheet view
    @Environment(\.modelContext) var context
    @Environment(\.dismiss) private var dismiss
    
    @State private var newExpense = Expense(name: "", date: .now, value: 0.0)
    
    var isFormValid: Bool {
        return !newExpense.name.isEmpty && newExpense.value > 0
    }
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Expense Name", text: $newExpense.name)
                DatePicker("Date", selection: $newExpense.date, displayedComponents: .date)
                TextField("Value", value: $newExpense.value, format: .currency(code: "USD"))
                    .keyboardType(.decimalPad)
            }
            .navigationTitle("New Expense")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel"){ dismiss() }
                }
                ToolbarItemGroup(placement: .confirmationAction) {
                    Button("Save") {
                        let expense = Expense(name: newExpense.name, date: newExpense.date, value: newExpense.value)
                        //Inserts data in the context container
                        context.insert(expense)
                        
                        dismiss()
                    }
                    .disabled(!isFormValid)
                }
                
            }

        }
    }
}

#Preview {
    let preview = previewContainer([Expense.self])
    return AddExpenseSheet().modelContainer(preview.container)
}
