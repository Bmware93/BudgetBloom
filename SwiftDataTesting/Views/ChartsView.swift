//
//  ChartsView.swift
//  SwiftDataExpensesTracker
//
//  Created by Benia Morgan-Ware on 1/29/24.
//

import SwiftUI
import Charts
import SwiftData


struct ChartsView: View {
    @Environment(\.modelContext) var context
    @Query(sort: \Expense.date) var expenses: [Expense]
    @State private var isAnimating = false
    
    func getMonthlyExpenseSum() -> TransactionGroup {
        guard !expenses.isEmpty else { return [:] }
        
        var groupedExpenses = TransactionGroup()
        
        for expense in expenses {
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
    
    var monthlySums: [ String: Double] {
        Dictionary(grouping: expenses, by: { $0.month })
            .mapValues { $0.reduce(0) { $0 + $1.value } }
    }
    
    
    var body: some View {
        NavigationStack {
            VStack {
                if expenses.isEmpty {
                    
                    ContentUnavailableView {
                        Label("No Data", systemImage: "creditcard.trianglebadge.exclamationmark")
                    } description: {
                        Text("Start adding expenses to see a summary of your monthly spending")
                    }
                    .offset(y: -60)
                    
                } else {
                    
                    Form {
                        let groupedExpenses = getMonthlyExpenseSum()
                        
                        HStack {
                            Text("Monthly Review")
                                .padding(.bottom)
                            
                            Spacer()
                            
                            VStack(spacing: -10) {
                                Text(String(format: "$%.2f", groupedExpenses.values.reduce(0){ $0 + $1.sum }))
                                    .padding(.bottom)
                                    .font(.headline)
                                    .bold()
                                
                                Text("Total Spent")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                
                            }
                        }
                        
                        
                        Chart(groupedExpenses.keys, id: \.self) { month in
                                if let group = groupedExpenses[month]  {
                                    BarMark(x: .value("Month", month),
                                            y: .value("Total Spent", isAnimating == false ? 50 : group.sum)
                                    )
                                    .foregroundStyle(Color.blue.gradient)
                                
                            }
                        }
                        .onAppear {
                            withAnimation {
                                isAnimating = true
                            }
                        }
                        .onDisappear {
                            isAnimating = false
                        }
                        .chartYScale(domain: 50...1000)
                        .frame(height: 170)
                        .padding(.bottom)
                        .chartXAxis {
                            AxisMarks(stroke: StrokeStyle(lineWidth: 0))
                            
                        }
                        
                        .chartYAxis{
                            AxisMarks(stroke: StrokeStyle(dash:[7]))
                        }
                        .listRowSeparator(.hidden)
                        
                        DisclosureGroup("Budget Insights") {
                            VStack(alignment: .leading, spacing: 10) {
                                HStack {
                                    Text("Daily Average")
                                        .padding(.trailing)
                                    Spacer()
                                    Text("$238.85")
                                        .bold()
                                }
                                Text("Great! You didn't exceed your daily average threshold of $250.")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                    .padding(.trailing, 40)
                            }
                            
                        }
                        
                    }
                    
                    
                }
    
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .navigationTitle("Summary")
        }
    }
}


#Preview {
    let preview = previewContainer([Expense.self])
    return ChartsView().modelContainer(preview.container)
}
