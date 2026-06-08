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
    
    // Natural language input
    @State private var nlInput: String = ""
    @State private var currentParsedResult: ParsedExpenseInput? = nil
    
    //@State private var accountId: String = ""
    @State private var name: String = ""
    @State private var date: Date = .now
    @State private var amount: Double = 0.0
    @State private var amountString: String = "0.00"
    @State private var hasStartedEditingAmount: Bool = false
    @FocusState private var isAmountFieldFocused: Bool
    @State private var spendingCategory:ExpenseCategory = .undefined
    @State private var expenseNotes: String = ""
    
    //Disabled add expense button until all data is entered
    var isFormValid: Bool {
         !name.isEmpty && amount > 0
    }
    
    // Parse natural language input and populate form fields
    private func parseAndPopulateFields(_ input: String) {
        guard !input.isEmpty else { 
            currentParsedResult = nil
            return 
        }
        
        let parsedResult = parseExpenseInput(input)
        
        // Store the parsed result for the preview card
        currentParsedResult = parsedResult
        
        // Update amount if parsed successfully
        if let parsedAmount = parsedResult.amount {
            amount = parsedAmount
            amountString = String(format: "%.2f", parsedAmount)
        }
        
        // Update name/merchant if parsed successfully
        if let parsedMerchant = parsedResult.merchant {
            name = parsedMerchant
        }
        
        // Update category if parsed successfully
        if let parsedCategory = parsedResult.category {
            // Find matching ExpenseCategory enum case
            if let matchingCategory = ExpenseCategory.allCases.first(where: { $0.rawValue == parsedCategory }) {
                spendingCategory = matchingCategory
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            Form {
                // Natural Language Input Section
                Section {
                    TextField("Add expense... (e.g., $25 groceries at Meijer)", text: $nlInput)
                        .textFieldStyle(.roundedBorder)
                        .submitLabel(.done)
                        .onChange(of: nlInput) { _, newValue in
                            parseAndPopulateFields(newValue)
                        }
                    
                    Text("Try natural language like \"$42 dinner at Olive Garden\" or \"15 coffee\"")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    // Preview card for parsed results
                    if !nlInput.isEmpty {
                        if let parsed = currentParsedResult,
                           (parsed.amount != nil || parsed.merchant != nil || parsed.category != nil) {
                            
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    if let amount = parsed.amount {
                                        Text("Amount: ")
                                            .foregroundColor(.secondary) +
                                        Text(currencyFormat(value: amount))
                                            .fontWeight(.medium)
                                    }
                                    
                                    Spacer()
                                    
                                    if let category = parsed.category {
                                        Text("Category: ")
                                            .foregroundColor(.secondary) +
                                        Text(category)
                                            .fontWeight(.medium)
                                    }
                                }
                                
                                if let merchant = parsed.merchant {
                                    HStack {
                                        Text("Merchant: ")
                                            .foregroundColor(.secondary) +
                                        Text(merchant)
                                            .fontWeight(.medium)
                                        
                                        Spacer()
                                    }
                                }
                            }
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                        } else if nlInput.count >= 3 {
                            // Show subtle hint for parsing failures (only if input is long enough)
                            HStack {
                                Image(systemName: "info.circle")
                                    .foregroundColor(.orange)
                                    .font(.caption)
                                
                                Text("Couldn't parse input. Try formats like \"$25 lunch at Chipotle\" or fill fields manually")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            .padding(.horizontal, 8)
                            .padding(.vertical, 6)
                            .background(Color(.systemYellow).opacity(0.1))
                            .cornerRadius(6)
                        }
                    }
                }
                
                // Manual Entry Section - Always visible for corrections
                Section("Expense Details") {
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
                        ForEach(ExpenseCategory.allCases, id: \.self) { option in
                            Text(option.rawValue)
                        }
                    }
                    .pickerStyle(.navigationLink)
                }
                
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
