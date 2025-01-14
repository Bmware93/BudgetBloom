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
    
    //@State private var accountId: String = ""
    @State private var name: String = ""
    @State private var date: Date = .now
    @State private var amount: Double = 0.0
    @State private var spendingCategory:SpendingCategory = .undefined
    @State private var expenseDescription: String = ""
    
    //Disabled add expense button until all data is entered
    var isFormValid: Bool {
         !name.isEmpty && amount > 0
    }
    
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Expense Name", text: $name)
                DatePicker("Date", selection: $date, displayedComponents: .date)
                TextField("Value", value: $amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                    .keyboardType(.decimalPad)
                    
                    
                Picker("Category", selection: $spendingCategory) {
                    ForEach(SpendingCategory.allCases, id: \.self) { option in
                        Text(option.rawValue)
                    }
                }
                .pickerStyle(.navigationLink)
                
                Section("Description") {
                    TextEditor(text: $expenseDescription)
                }
            }
            .navigationTitle("New Expense")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel"){ dismiss() }
                }
                ToolbarItemGroup(placement: .confirmationAction) {
                    Button("Save") {
                        let expense = Expense(name: name, date: date, amount: amount, category: spendingCategory, expenseDescription: expenseDescription)
                        //Inserts data in the context container
                        context.insert(expense)
                        
                        //Close out view once all the data has been entered
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
