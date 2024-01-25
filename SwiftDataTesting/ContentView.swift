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
               // VStack {
                    List {
                        ForEach(Array(groupExpensesByMonth()), id: \.key) { month, expense in
                            Section {
                                ForEach(expense) { expense in
                                    ExpenseCellView(expense: expense)
                                        .onTapGesture {
                                            expenseToEdit = expense
                                        }
                                }
                                .onDelete { indexset in
                                    for index in indexset {
                                        context.delete(expenses[index])
                                    }
                                }
                            } header: {
                                Text(month)
                            }
                        
                        }
                    }
                    .listStyle(PlainListStyle())
                    //.listSectionSeparator(.hidden)
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
           // }
       }
    }

#Preview {
    let preview = previewContainer([Expense.self])
    return ContentView().modelContainer(preview.container)
}




