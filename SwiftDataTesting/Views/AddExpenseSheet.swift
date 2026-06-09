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
    
    // Category-specific gradient colors
    private func categoryGradientColors(for category: ExpenseCategory) -> [Color] {
        switch category {
        case .food:
            return [Color.orange.opacity(0.1), Color.red.opacity(0.05)]
        case .entertainment:
            return [Color.purple.opacity(0.1), Color.pink.opacity(0.05)]
        case .transportation:
            return [Color.blue.opacity(0.1), Color.cyan.opacity(0.05)]
        case .clothing:
            return [Color.green.opacity(0.1), Color.mint.opacity(0.05)]
        case .health:
            return [Color.red.opacity(0.1), Color.pink.opacity(0.05)]
        case .travel:
            return [Color.pink.opacity(0.15), Color.orange.opacity(0.08)]
        case .utilities:
            return [Color.gray.opacity(0.1), Color.secondary.opacity(0.05)]
        case .education:
            return [Color.indigo.opacity(0.1), Color.purple.opacity(0.05)]
        case .housing:
            return [Color.brown.opacity(0.1), Color.orange.opacity(0.05)]
        case .toiletries:
            return [Color.cyan.opacity(0.1), Color.blue.opacity(0.05)]
        case .subscription:
            return [Color.purple.opacity(0.1), Color.indigo.opacity(0.05)]
        case .childcare:
            return [Color.yellow.opacity(0.1), Color.orange.opacity(0.05)]
        case .debt:
            return [Color.red.opacity(0.1), Color.gray.opacity(0.05)]
        case .groceries:
            return [Color.green.opacity(0.1), Color.yellow.opacity(0.05)]
        case .personal:
            return [Color.pink.opacity(0.1), Color.purple.opacity(0.05)]
        case .pet:
            return [Color.brown.opacity(0.1), Color.yellow.opacity(0.05)]
        case .charity:
            return [Color.mint.opacity(0.1), Color.green.opacity(0.05)]
        case .saving:
            return [Color.green.opacity(0.1), Color.mint.opacity(0.05)]
        case .gifts:
            return [Color.pink.opacity(0.1), Color.red.opacity(0.05)]
        case .maintenance:
            return [Color.orange.opacity(0.1), Color.brown.opacity(0.05)]
        case .insurance:
            return [Color.blue.opacity(0.1), Color.gray.opacity(0.05)]
        case .business:
            return [Color.indigo.opacity(0.1), Color.blue.opacity(0.05)]
        case .investments:
            return [Color.green.opacity(0.1), Color.blue.opacity(0.05)]
        case .misc:
            return [Color.gray.opacity(0.1), Color.secondary.opacity(0.05)]
        case .undefined:
            return [Color(.systemBackground), Color(.systemGray6).opacity(0.3)]
        }
    }
    
    // Category-specific SF Symbols
    private func categoryIcon(for category: ExpenseCategory) -> String {
        switch category {
        case .food:
            return "fork.knife"
        case .entertainment:
            return "tv"
        case .transportation:
            return "car"
        case .clothing:
            return "tshirt"
        case .health:
            return "cross.case"
        case .travel:
            return "airplane"
        case .utilities:
            return "bolt"
        case .education:
            return "book"
        case .housing:
            return "house"
        case .toiletries:
            return "drop"
        case .subscription:
            return "tv.badge.wifi"
        case .childcare:
            return "figure.child"
        case .debt:
            return "creditcard.trianglebadge.exclamationmark"
        case .groceries:
            return "cart"
        case .personal:
            return "person"
        case .pet:
            return "pawprint"
        case .charity:
            return "heart"
        case .saving:
            return "banknote"
        case .gifts:
            return "gift"
        case .maintenance:
            return "wrench"
        case .insurance:
            return "shield"
        case .business:
            return "briefcase"
        case .investments:
            return "chart.line.uptrend.xyaxis"
        case .misc:
            return "ellipsis.circle"
        case .undefined:
            return "questionmark.circle"
        }
    }
    
    // Category-specific accent colors
    private func categoryAccentColor(for category: ExpenseCategory) -> Color {
        switch category {
        case .food:
            return .orange
        case .entertainment:
            return .purple
        case .transportation:
            return .blue
        case .clothing:
            return .green
        case .health:
            return .red
        case .travel:
            return .pink
        case .utilities:
            return .gray
        case .education:
            return .indigo
        case .housing:
            return .brown
        case .toiletries:
            return .cyan
        case .subscription:
            return .purple
        case .childcare:
            return .yellow
        case .debt:
            return .red
        case .groceries:
            return .green
        case .personal:
            return .pink
        case .pet:
            return .brown
        case .charity:
            return .mint
        case .saving:
            return .green
        case .gifts:
            return .pink
        case .maintenance:
            return .orange
        case .insurance:
            return .blue
        case .business:
            return .indigo
        case .investments:
            return .green
        case .misc:
            return .gray
        case .undefined:
            return .secondary
        }
    }
    
    var body: some View {
        NavigationStack {
            Form {
                // Natural Language Input Section
               // Section {
                    VStack(spacing: 16) {
                        // Header with sparkles icon
                        HStack {
                            Image(systemName: "sparkles")
                                .foregroundColor(.white)
                                .font(.system(size: 14, weight: .medium))
                                .frame(width: 24, height: 24)
                                .background(Color.purple)
                                .clipShape(RoundedRectangle(cornerRadius: 6))
                            
                            Text("JUST DESCRIBE IT")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundColor(.primary)
                                .tracking(0.5)
                            
                            Spacer()
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        
                        // Natural language input field
                        TextField("$42 dinner at Olive Garden", text: $nlInput)
                            .font(.system(size: 20, weight: .regular))
                            .padding(.horizontal, 20)
                            .submitLabel(.done)
                            .onChange(of: nlInput) { _, newValue in
                                parseAndPopulateFields(newValue)
                            }
                        
                        // Hero amount and chips - only show when parsed
                        if let parsed = currentParsedResult,
                           let amount = parsed.amount {
                            
                            VStack(spacing: 16) {
                                // Amount and category chip in same row
                                HStack(spacing: 12) {
                                    // Green amount pill
                                    HStack(spacing: 4) {
                                       
                                        Text(currencyFormat(value: amount))
                                            .font(.system(size: 14, weight: .medium))
                                            .foregroundColor(.green)
                                    }
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(Color.green.opacity(0.1))
                                    .clipShape(Capsule())
                                    
                                    // Category chip with SF Symbol
                                    if spendingCategory != .undefined {
                                        HStack(spacing: 6) {
                                            Image(systemName: categoryIcon(for: spendingCategory))
                                                .font(.system(size: 12, weight: .medium))
                                                .foregroundColor(.white)
                                            Text(spendingCategory.rawValue)
                                                .font(.system(size: 13, weight: .medium))
                                                .foregroundColor(.white)
                                        }
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 8)
                                        .background(categoryAccentColor(for: spendingCategory))
                                        .clipShape(Capsule())
                                    }
                                    
                                    Spacer()
                                }
                                
                                // Merchant name with house icon
                                if !name.isEmpty {
                                    HStack {
                                        Image(systemName: "house.fill")
                                            .font(.system(size: 14))
                                            .foregroundColor(.purple)
                                        Text(name)
                                            .font(.system(size: 16, weight: .medium))
                                            .foregroundColor(.purple)
                                        Spacer()
                                    }
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, 20)
                        }
                    }
                    .background {
                        // Dynamic gradient background based on parsed category
                        if let parsed = currentParsedResult, parsed.amount != nil {
                            // Category-specific gradient
                            LinearGradient(
                                colors: categoryGradientColors(for: spendingCategory),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        } else {
                            // Neutral gradient when nothing is parsed
                            LinearGradient(
                                colors: [
                                    Color(.systemBackground),
                                    Color(.systemGray6).opacity(0.3)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        }
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
               // }
                
                // Expense Details Section with styled layout
                Section {
                    // Name field with icon
                    HStack {
                        Image(systemName: "doc.text")
                            .foregroundColor(.secondary)
                            .frame(width: 20)
                        
                        TextField("Expense Name", text: $name)
                            .submitLabel(.continue)
                    }
                    
                    // Amount field with icon
                    HStack {
                        Image(systemName: "creditcard")
                            .foregroundColor(.secondary)
                            .frame(width: 20)
                        
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
                    }
                    
                    // Category field with icon
                    HStack {
                        Image(systemName: "tag")
                            .foregroundColor(.secondary)
                            .frame(width: 20)
                        
                        Picker("Category", selection: $spendingCategory) {
                            ForEach(ExpenseCategory.allCases, id: \.self) { option in
                                Text(option.rawValue)
                            }
                        }
                        .pickerStyle(.navigationLink)
                        .foregroundColor(categoryAccentColor(for: spendingCategory))
                    }
                    
                    // Date field with icon
                    HStack {
                        Image(systemName: "calendar")
                            .foregroundColor(.secondary)
                            .frame(width: 20)
                        
                        DatePicker("Date", selection: $date, displayedComponents: .date)
                    }
                } header: {
                    HStack {
                        Text("DETAILS")
                        Label("auto-filled", systemImage: "sparkles")
                    }
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

// Helper view for category selection
struct CategoryPicker: View {
    @Binding var selection: ExpenseCategory
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        List {
            ForEach(ExpenseCategory.allCases, id: \.self) { category in
                Button {
                    selection = category
                    dismiss()
                } label: {
                    HStack {
                        Text(category.rawValue)
                            .foregroundColor(.primary)
                        
                        Spacer()
                        
                        if selection == category {
                            Image(systemName: "checkmark")
                                .foregroundColor(.blue)
                        }
                    }
                }
            }
        }
        .navigationTitle("Category")
        .navigationBarTitleDisplayMode(.inline)
    }
}
