//
//  ContentView.swift
//  SwiftDataTesting
//
//  Created by Benia Morgan-Ware on 11/28/23.
//

import SwiftUI
import SwiftData


struct ContentView: View {
    @State private var isItemSheetShowing = false
    
    //injecting context into the content view so it will have access to it
    @Environment(\.modelContext) var context
    
    //fetches the saved data from the context in the add expense sheet
    @Query(sort: \Expense.date) var expenses: [Expense]
    @State private var expenseToEdit: Expense?
    @State private var searchText = ""
    
    var searchResults: [Expense] {
        if searchText.isEmpty {
            return expenses
        } else {
           return expenses.filter { expense in
               let nameMatch = expense.name.lowercased().contains(searchText.lowercased())
               
               return nameMatch
            }
        }
    }
    
    func groupExpensesByMonth() -> transactionGroup {
        guard !searchResults.isEmpty else { return [:] }
        let groupedExpenses = transactionGroup(grouping: searchResults) { $0.month}
        
        return groupedExpenses
    }
    
    
    var body: some View {
            NavigationStack {
                List {
                    ForEach(Array(groupExpensesByMonth()), id: \.key) { month, expense in
                        Section {
                            ForEach(expense) { expense in
                                ExpenseCell(expense: expense)
                                    .onTapGesture {
                                        expenseToEdit = expense
                                    }
                            }
                        } header: {
                            Text(month)
                        }
                    }
                }
                .navigationTitle("Expenses")
                .navigationBarTitleDisplayMode(.large)
                .searchable(text: $searchText)
                .sheet(isPresented: $isItemSheetShowing) { AddExpenseSheet() }
                .sheet(item: $expenseToEdit) { expense in
                    EditExpenseSheet(expense: expense)
                }
                .toolbar {
                    if !expenses.isEmpty {
                        Button("Add Expense", systemImage: "plus") {
                            isItemSheetShowing.toggle()
                        }
                    }
                }
                .overlay {
                    if expenses.isEmpty {
                        ContentUnavailableView(label: {
                            Label("No Expenses", systemImage: "list.bullet.rectangle.portrait")
                        },description: {
                            Text("Start adding expenses to see your list")
                        }, actions: {
                            Button("Add Expense") {
                                isItemSheetShowing.toggle()
                            }
                        })
                        .offset(y: -60)
                    }
                }
            }
        }
    }

#Preview {
    ContentView()
}

//#Preview { 
//    let preview = previewContainer([Expense.self])
//    return ExpenseCell(expense: Expense(name: "The Red Hook", date: .now, value: 12.80)).modelContainer(preview.container)
//}

struct ExpenseCell: View {
    
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

struct AddExpenseSheet: View {
    
    //Inserting the model context into the expense sheet view
    @Environment(\.modelContext) var context
    @Environment(\.dismiss) private var dismiss
    
    @State private var newExpense = Expense(name: "", date: .now, value: 0.0)
    
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
                        let expense = Expense(name: newExpense.name, date: newExpense.dateParsed, value: newExpense.value)
                        //Inserts data in the context container
                        context.insert(expense)
                        
                        dismiss()
                    }
                }
                
            }

        }
    }
}


struct EditExpenseSheet: View {
    @Environment(\.dismiss) private var dismiss
    
    @Bindable var expense: Expense
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Expense Name", text: $expense.name)
                DatePicker("Date", selection: $expense.date, displayedComponents: .date)
                TextField("Value", value: $expense.value, format: .currency(code: "USD"))
                    .keyboardType(.decimalPad)
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




