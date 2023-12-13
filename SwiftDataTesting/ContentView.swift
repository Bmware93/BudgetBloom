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
    
    
    var body: some View {
            NavigationStack {
                List {
                    ForEach(expenses) { expense in
                        ExpenseCell(expense: expense)
                            .onTapGesture {
                                expenseToEdit = expense
                            }
                    }
                    //code that allows us to delete an expense item
                    //Swipe to delete comes with on delete method
                    .onDelete { indexSet in
                        for index in indexSet {
                            context.delete(expenses[index])
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


#Preview { ContentView()}

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
    
    @State private var name: String = ""
    @State private var date: Date = .now
    @State private var value: Double = 0
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Expense Name", text: $name)
                DatePicker("Date", selection: $date, displayedComponents: .date)
                TextField("Value", value: $value, format: .currency(code: "USD"))
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
                        let expense = Expense(name: name, date: date, value: value)
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




