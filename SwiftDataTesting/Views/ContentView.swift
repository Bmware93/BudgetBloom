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
            //expense array is reveresed so that the most recent is showing first
            return expenses.reversed()
        } else {
            return expenses.filter { expense in
                let nameMatch = expense.name.lowercased().contains(searchText.lowercased())
                
                return nameMatch
            }
        }
    }
    
    func groupExpensesByMonth() -> transactionGroup {
        guard !searchResults.isEmpty else { return [:] }
        
        var groupedExpenses = transactionGroup()
        
        for expense in searchResults {
            //Getting the month from the expense
            let month = expense.month
            
            // If the month is already a key in the dictionary, append the expense to the existingGrp array
            // and update the sum of values
            if var existingGroup = groupedExpenses[month] {
                existingGroup.expenses.append(expense)
                existingGroup.sum += expense.value
                
                groupedExpenses[month] = existingGroup
            } else {
                // If the month is not a key in the dictionary, create a new entry with the expense in an array
                // and set the sum of values to the expense value
                groupedExpenses[month] = (expenses: [expense] , sum: expense.value)
            }
        }
        return groupedExpenses
    }
    
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(groupExpensesByMonth().keys, id: \.self) { month in
                    if let group = groupExpensesByMonth()[month] {
                        Section {
                            ForEach(group.expenses) { expense in
                                ExpenseCellView(expense: expense)
                                    .onTapGesture {
                                        expenseToEdit = expense
                                    }
                            }
                            .onDelete { indexset in
                                for index in indexset {
                                    context.delete(group.expenses[index])
                                }
                            }
                        } header: {
                            Text(month)
                        } footer: {
                            HStack {
                                Spacer()
                                Text("Total \(group.sum.formatted(.currency(code: "USD")))")
                                    .font(.footnote)
                                    .foregroundStyle(.blue)
                            }
                        }
                    }
                }
                .listSectionSeparator(.hidden, edges: .bottom)
            }
            .listStyle(PlainListStyle())
            .navigationTitle("Expense Tracker")
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
    let preview = previewContainer([Expense.self])
    return ContentView().modelContainer(preview.container)
}




