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
    
    @State private var name: String = ""
    @State private var date: Date = .now
    @State private var value: Double = 0.0
    @State private var spendingCategory:SpendingCategory = .clothing
    
    //Disabled add expense button until all data is entered
    var isFormValid: Bool {
        return !name.isEmpty && value > 0
    }
    
    
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Expense Name", text: $name)
                DatePicker("Date", selection: $date, displayedComponents: .date)
                TextField("Value", value: $value, format: .currency(code: "USD"))
                    .keyboardType(.decimalPad)
                Picker("Category", selection: $spendingCategory) {
                    ForEach(SpendingCategory.allCases, id: \.self) { option in
                        Text(option.rawValue)
                    }
                }
                .pickerStyle(.navigationLink)
            }
            .navigationTitle("New Expense")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel"){ dismiss() }
                }
                ToolbarItemGroup(placement: .confirmationAction) {
                    Button("Save") {
                        let expense = Expense(name: name, date: date, value: value, category: spendingCategory)
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
