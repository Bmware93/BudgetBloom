//
//  ContentView.swift
//  SwiftDataTesting
//
//  Created by Benia Morgan-Ware on 11/28/23.
//

import SwiftUI
import SwiftData


struct ContentView: View {

    //injecting context into the content view so it will have access to the database
    @Environment(\.modelContext) var context
    
    //fetches the saved data from the context 
    //expense array is reveresed so that the most recent expense is showing first
    @Query(sort: \Expense.date, order: .reverse) var expenses: [Expense]
    
    @State private var isItemSheetShowing = false
    @State private var expenseToEdit: Expense?
    @State private var searchText = ""
    
   var searchResults: [Expense] {
        if searchText.isEmpty {
            expenses
        } else {
            expenses.filter { expense in
                expense.name.localizedStandardContains(searchText)
            }
        }
    }
    
    func groupExpensesByMonth() -> TransactionGroup {
        guard !expenses.isEmpty else { return [:] }
        
        var groupedExpenses = TransactionGroup()
        
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
                let groupedExpenses = groupExpensesByMonth()
                
                ForEach(groupedExpenses.keys, id: \.self) { month in
                    if let group = groupedExpenses[month] {
                        Section {
                            ForEach(group.expenses) { expense in
                                ExpenseCellView(expense: expense)
                                    .onTapGesture {
                                        expenseToEdit = expense
                                    }
                                    .accessibilityAddTraits(.isButton)
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
                                    .font(.footnote).bold()
                                    .foregroundStyle(.blue)
                            }
                        }
                    }
                }
                .listSectionSeparator(.hidden, edges: .bottom)
            }
            .listStyle(.plain)
            .navigationTitle("Spending Tracker")
            .searchable(text: $searchText)
            .sheet(isPresented: $isItemSheetShowing, content: AddExpenseSheet.init)
            .sheet(item: $expenseToEdit, content: EditExpenseSheet.init)
            .toolbar {
                if !expenses.isEmpty {
                    Button("Add Expense", systemImage: "plus") {
                        isItemSheetShowing.toggle()
                    }
                }
            }
            .overlay {
                if expenses.isEmpty {
                    ContentUnavailableView {
                        Label("No Expenses", systemImage: "list.bullet.rectangle.portrait")
                    } description: {
                        Text("Start adding expenses to see your list")
                    }  actions: {
                        Button("Add Expense") {
                            isItemSheetShowing.toggle()
                        }
                    }
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




