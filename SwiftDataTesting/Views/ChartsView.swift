//
//  ChartsView.swift
//  SwiftDataExpensesTracker
//
//  Created by Benia Morgan-Ware on 1/29/24.
//

import SwiftUI
import Charts
//import Collections
import SwiftData


struct ChartsView: View {
    @Environment(\.modelContext) var context
    @Query(sort: \Expense.date) var expenses: [Expense]
    
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
    
    
    var body: some View {
        NavigationStack {
            VStack {
                //Spacer()
                Chart {
                    ForEach(getMonthlyExpenseSum().keys, id: \.self) { month in
                        if let group = getMonthlyExpenseSum()[month]  {
                            BarMark(x: .value("Month", month),
                                    y: .value("Total Spent", group.sum)
                            )
                            .foregroundStyle(Color.blue.gradient)
                        }
                    }
                }
                .frame(height: 300)
                .chartXAxis {
                    AxisMarks(stroke: StrokeStyle(lineWidth: 0))
                    //AxisTick(centered: true)
                }
                .chartYAxis{
                    AxisMarks(position: .leading)
                }
            }
            .navigationTitle("Expense Summary")
        }
    }
}


#Preview {
    let preview = previewContainer([Expense.self])
    return ChartsView().modelContainer(preview.container)
}
