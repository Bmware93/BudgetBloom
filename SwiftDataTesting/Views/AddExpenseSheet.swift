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
    @State private var amountString: String = "0.00"
    @State private var hasStartedEditingAmount: Bool = false
    @FocusState private var isAmountFieldFocused: Bool
    @State private var spendingCategory:SpendingCategory = .undefined
    @State private var expenseNotes: String = ""
    
    //Disabled add expense button until all data is entered
    var isFormValid: Bool {
         !name.isEmpty && amount > 0
    }
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Expense Name", text: $name)
                    .submitLabel(.continue)
                DatePicker("Date", selection: $date, displayedComponents: .date)
                TextField("Amount", text: $amountString, prompt: Text(currencyFormat(value: amount)))
                    .keyboardType(.decimalPad)
                    .submitLabel(.continue)
                    .focused($isAmountFieldFocused)
                    .onChange(of: isAmountFieldFocused) {
                        if isAmountFieldFocused && !hasStartedEditingAmount {
                            amountString = ""
                            hasStartedEditingAmount = true
                        }
                    }
                    .onAppear {
                        if amount >= 0 {
                            amountString = String(format: currencyFormat(value: amount))
                        }
                    }
                    .onDisappear {
                        // Clean the amountString by removing non-numeric characters except the decimal
                                let cleanedAmount = amountString
                                    .filter { "0123456789.".contains($0) }
                                
                                // Convert to Double after cleaning
                                amount = Double(cleanedAmount) ?? 0
                    }
                    
                Picker("Category", selection: $spendingCategory) {
                    ForEach(SpendingCategory.allCases, id: \.self) { option in
                        Text(option.rawValue)
                    }
                }
                .pickerStyle(.navigationLink)
                
                Section("Notes") {
                    TextEditor(text: $expenseNotes)
                        .font(.custom("HelveticaNeue", size: 18))
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
                        let expense = Expense(name: name, date: date, amount: amount, category: spendingCategory, expenseDescription: expenseNotes)
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
