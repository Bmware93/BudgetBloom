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
    @State private var barGraphIsAnimating = false
    @State private var donutGraphIsAnimating = false
    @State private var barGraphPicker: TimePeriods = .year
 
    
    func getMonthlyExpenseSum() -> TransactionGroup {
        guard !expenses.isEmpty else { return [:] }
        
        var groupedExpenses = TransactionGroup()
        
        for expense in expenses {
            //Getting the month from the expense
            //Short month is the abbreviated version
            let month = expense.shortMonth
            
            // If the month is already a key in the dictionary, append the expense to the existingGrp array
            // and update the sum of values
            if var existingGroup = groupedExpenses[month] {
                existingGroup.expenses.append(expense)
                existingGroup.sum += expense.amount
                
                groupedExpenses[month] = existingGroup
            } else {
                // If the month is not a key in the dictionary, create a new entry with the expense in an array
                // and set the sum of values to the expense value
                groupedExpenses[month] = (expenses: [expense] , sum: expense.amount)
            }
        }
        return groupedExpenses
    }
    
    var categoryTotals: [SpendingCategory: Double] {
        Dictionary(grouping: expenses, by: {$0.category})
            .mapValues{$0.reduce(0) {$0 + $1.amount }}
    }
    
    var topCategoryTotals: [CategoryTotal] {
        categoryTotals
            .map { CategoryTotal(category: $0.key, total: $0.value) }
            .sorted { $0.total > $1.total } // Sorting to get the highest totals
            .prefix(4) // Taking only the top 4
            .map { $0 } // Map to array
    }
    
    
    //Converting above dictionary to an array of CategoryTotal objects.
    var categoryTotalData: [CategoryTotal] {
        categoryTotals.map { CategoryTotal(category: $0.key, total: $0.value) }
    }
    
    //Time periods for picker in graph view
    //Will adjust based on how user wants to view their spending
    enum TimePeriods: String, CaseIterable, Identifiable {
        case day   = "Today"
        case week  = "This Week"
        case month = "This Month"
        case year  = "This Year"
        
        var id: String { rawValue }
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
                    
                    VStack {
                        Form {
                            
                            let groupedExpenses = getMonthlyExpenseSum()
                            
                            HStack {
                                Menu {
                                    ForEach(TimePeriods.allCases, id: \.self) { option in
                                        Button {
                                            self.barGraphPicker = option
                                        } label: {
                                            Label(option.rawValue, systemImage: "")
                                        }
                                        
                                    }
                                    
                                } label: {
                                    Text(barGraphPicker.rawValue)
                                        .font(.system(size: 18))
                                    Image(systemName: "chevron.up.chevron.down")
                                        .font(.caption)
                                }
                                .foregroundStyle(.primary)
                                
                                
                                
                                Spacer()
                                
                                VStack(spacing: -10) {
                                    Text(currencyFormat(value: groupedExpenses.values.reduce(0) { $0 + $1.sum }))
                                        .padding(.bottom)
                                        .font(.headline)
                                        .bold()
                                    
                                    Text("Total Spent")
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                    
                                }
                            }
                            .padding(.bottom, 25)
                            
                            //Getting max amount spent in a month
                            //Defaults to 1000 is no values exist
                            let maxSpending = groupedExpenses.values.map {$0.sum }.max() ?? 1000
                            
                            //MARK: Bar Chart starts here
                            Chart(groupedExpenses.keys, id: \.self) { month in
                                if let group = groupedExpenses[month]  {
                                    
                                    BarMark(x: .value("Month", month),
                                            y: .value("Total Spent", barGraphIsAnimating == false ? 50 : group.sum)
                                    )
                                    .foregroundStyle(by: .value("Month", month))
                                    
                                }
                                
                            }
                            .chartLegend(.hidden)
                            .chartForegroundStyleScale(range: [Color.DarkBlue, Color.brandGreen, Color.navyBlue, Color.lightblue])
                            .onAppear {
                                withAnimation {
                                    barGraphIsAnimating = true
                                }
                            }
                            .onDisappear {
                                barGraphIsAnimating = false
                            }
                            .chartYScale(domain: 50...maxSpending)
                            //.padding(.bottom, 40)
                            .frame(height: 140)
                            
                            .chartXAxis {
                                AxisMarks(stroke: StrokeStyle(lineWidth: 0))
                                
                            }
                            
                            .chartYAxis {
                                AxisMarks(stroke: StrokeStyle(dash:[7]))
                            }
                            .listRowSeparator(.hidden)
                            
                            
                            DisclosureGroup("Spending Insights") {
                                VStack {
                                    HStack {
                                        Text("Top Spending by Category")
                                
                                    }
                                    //MARK: Donut Chart starts here
                                    DonutChartView(categoryTotals: topCategoryTotals)
                                    
                                }
                                
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


struct DonutChartView: View {
    let categoryTotals: [CategoryTotal]
    @State private var isAnimating = false
    
    var body: some View {
        Chart(categoryTotals) { item in
            SectorMark(angle: .value("Total Spent",
                                     isAnimating == false ? 0 : item.total ),
                       innerRadius: .ratio(0.5))
            
            .position(by: .value("Category", item.category.rawValue))
            .foregroundStyle(by: .value("Category", item.category.rawValue))
            .position(by: .value("Value", item.total))
            
            
            .cornerRadius(5)
            
        }
        
        .frame(width: 280, height: 250)
        .chartLegend(alignment:.bottomLeading,spacing: 20)
        
        .chartForegroundStyleScale(
            range: [Color.DarkBlue, .lightblue, .navyBlue, .brandGreen])
        .onAppear {
            withAnimation(.smooth) {
                isAnimating = true
            }
            
            
        }
        .onDisappear {
            isAnimating = false
        }
    }
}

#Preview {
    DonutChartView(categoryTotals: [])
}


#Preview {
    let preview = previewContainer([Expense.self])
    return ChartsView().modelContainer(preview.container)
}
