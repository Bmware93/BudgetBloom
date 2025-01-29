//
//  BarChartView.swift
//  SwiftDataExpensesTracker
//
//  Created by Benia Morgan-Ware on 5/29/24.
//

import SwiftUI
import Charts


struct BarChartView: View {
    @State private var isAnimating = false
    @State private var rawSelectedDate: String?
    let groupedExpenses: TransactionGroup
    var selectedMonth: String? {
        guard let rawSelectedDate else { return nil }
        return groupedExpenses.keys.first(where: { $0 == rawSelectedDate })
    }
    
    //Getting max amount spent in a month
    //Defaults to 1000 if no values exist
    var maxSpending: Double {
        groupedExpenses.values.map {$0.sum }.max() ?? 1000
    }
    var minSpending: Double {
        groupedExpenses.values.map {$0.sum }.min() ?? 50
    }
    
    var body: some View {
        
        Chart {
            ForEach(groupedExpenses.keys, id: \.self) { month in
                if let group = groupedExpenses[month] {
                    
                    BarMark(
                        x: .value("Month", month),
                        y: .value("Total Spent", isAnimating == false ? 50 : group.sum)
                    )
                    .foregroundStyle(by: .value("Month", month))
                    .opacity(rawSelectedDate == nil  || month == selectedMonth ? 1.0 : 0.3)
                    .cornerRadius(5)
                }
            }
            if let selectedMonth, let selectedGroup = groupedExpenses[selectedMonth] {
                        RuleMark(x: .value("Selected Month", selectedMonth))
                            .foregroundStyle(.secondary.opacity(0.3))
                            .annotation(alignment: .top, overflowResolution: .init(x: .fit(to: .chart), y: .disabled)) {
                                VStack {
                                    Text(selectedMonth)
                                        .bold()
                                    
                                    Text(currencyFormat(value: selectedGroup.sum))
                    }
                }
            }
        }
        .frame(height: 200)
        .chartLegend(.hidden)
        .chartXSelection(value: $rawSelectedDate.animation(.easeInOut))
        .chartForegroundStyleScale(range: [Color.bbLGreen, .bbLPurple,.bbDarkGreen])
        .animateOnAppear(isAnimating: $isAnimating)
        .chartYScale(domain: 0...maxSpending)
        .padding(.bottom, 20)
        .chartXAxis {
            AxisMarks(values: .automatic, stroke: StrokeStyle(lineWidth: 0))
        }
        .chartYAxis {
            AxisMarks(stroke: StrokeStyle(dash:[7]))
        }
        .listRowSeparator(.hidden)
    }
}

#Preview {
    BarChartView(groupedExpenses: [
        "January": (
            expenses: [
                Expense(name: "Apples", date: Date(), amount: 5.50, category: .food, expenseDescription: ""),
                Expense(name: "Movie Ticket", date: Date(), amount: 12.00, category: .entertainment, expenseDescription: ""),
                Expense(name: "Electricity Bill", date: Date(), amount: 50.00, category: .utilities, expenseDescription: "")
            ],
            sum: 67.50
        ),
        "February": (
            expenses: [
                Expense(name: "Bread", date: Date(), amount: 3.75, category: .food, expenseDescription: ""),
                Expense(name: "Gas", date: Date(), amount: 40.00, category: .transportation, expenseDescription: ""),
                Expense(name: "Streaming Subscription", date: Date(), amount: 15.99, category: .subscription, expenseDescription: "")
            ],
            sum: 59.74
        ),
        "March": (
            expenses: [
                Expense(name: "Milk", date: Date(), amount: 4.00, category: .food, expenseDescription: ""),
                Expense(name: "Water Bill", date: Date(), amount: 30.25, category: .utilities, expenseDescription: ""),
                Expense(name: "Bus Ticket", date: Date(), amount: 2.50, category: .transportation, expenseDescription: "")
            ],
            sum: 36.75
        )])
    //.frame(minHeight: 230)
}
