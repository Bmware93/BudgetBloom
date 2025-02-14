//
//  EditExpenseSheet.swift
//  SwiftDataExpensesTracker
//
//  Created by Benia Morgan-Ware on 1/4/24.
//

import SwiftUI
import SwiftData

struct EditExpenseSheetView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var expense: Expense
    var isFormValid: Bool {
        !expense.name.isEmpty && expense.amount > 0
    }
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Expense Name", text: $expense.name)
                DatePicker("Date", selection: $expense.date, displayedComponents: .date)
                TextField("Value", value: $expense.amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                    .keyboardType(.decimalPad)
                Picker("Category", selection: $expense.category){
                    ForEach(SpendingCategory.allCases, id: \.self) { option in
                        Text(option.rawValue)
                        
                    }
                }
                .pickerStyle(.navigationLink)
                
                Section("Notes") {
                    TextEditor(text: $expense.expenseDescription)
                }
            }
            .navigationTitle("Update Expense")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
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
    return EditExpenseSheetView(expense: Expense(name: "The Red Hook", date: .now, amount: 10, category: .food, expenseDescription: "Bought 2x chai lattes")).modelContainer(preview.container)
}
