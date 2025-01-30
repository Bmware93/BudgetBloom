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
    let chartColors = [Color.bbDarkGreen, .bbLGreen, .bbLPurple, .bloomPink, .bbDarkPurple]
    @State private var selectedCount: Double?
    @State var selectedCategory: CategoryTotal?
    @State private var currentGraphTimeFrame: TimePeriods = .year
    
    var groupedExpenses: TransactionGroup {
        switch currentGraphTimeFrame {
        case .day:
            return getDailyExpenseSum(expenses: expenses, for: Date())
        case .week:
            return getWeeklyExpenseSum(expenses: expenses, for: Date())
        case .month:
            return transactionGroupForCurrentMonth(expenses:expenses)
        case .year://this function is currently pulling all expenses spent in the array not just those in the current year. Will update soon
            return getTotalExpenseSum(expenses: expenses)
        }
    }
    
    var donutChartData: [CategoryTotal] {
        switch currentGraphTimeFrame {
        case .day:
            return getTodayCategoryTotals(from: expenses)
        case .week:
            return getWeekCategoryTotals(from: expenses)
        case .month:
            return getMonthCategoryTotals(from: expenses)
        case .year:
            return getYearCategoryTotals(from: expenses)
        }
    }
    
    func contentUnavailablemessage() -> some View {
        var message: String {
            switch currentGraphTimeFrame {
            case .day:
                return "🌱 Nothing spent today"
            case .week:
                return "🌱 A quiet week so far"
            case .month:
                return "🌱 A fresh start this month"
            case .year:
                return "🌱 Your year awaits"
            }
        }
        
        var description: Text {
           switch currentGraphTimeFrame {
           case .day:
                return Text("Looks like your wallet’s enjoying a break! Add your expenses to start cultivating today’s spending insights.")
            case .week:
                return Text("Log some expenses to see how your spending shapes up over the days.")
            case .month:
                return Text("Start recording your expenses to see your monthly spending.")
            case .year:
                return Text("Add some expenses to track how your spending blossoms over the year.")
            }
        }
        return ContentUnavailableView(message, image: "", description: description)
    }
    
    func totalSpentLabel(for expenses: TransactionGroup) -> some View {
        VStack(spacing: -10) {
            Text(currencyFormat(value: expenses.values.reduce(0) { $0 + $1.sum }))
                .padding(.bottom)
                .font(.headline)
                .bold()
            
            Text("Total Spent")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }
    
    func color(for category: SpendingCategory) -> Color {
        guard let index = donutChartData.firstIndex(where: { $0.category == category }),
              index < chartColors.count else {
            return .gray // Default color for categories not in the top 4
        }
        return chartColors[index]
    }
    
    var categoryTotals: [SpendingCategory: Double] {
        Dictionary(grouping: expenses, by: {$0.category})
            .mapValues{$0.reduce(0) {$0 + $1.amount }}
    }
    
    var expensesFromTopTotal: [SpendingCategory: [Expense]] {
        Dictionary(grouping: expenses, by: {$0.category})
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
    
    func getSelectedCategory(value: Double) -> CategoryTotal?{
        var cumulativeTotal = 0.0
        return categoryTotalData.first { category in
            cumulativeTotal += category.total
            if value <= cumulativeTotal {
                selectedCategory = category
                return true
            }
            return false
        }
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
                    
                    //VStack {
                        List {
                            
                            let groupedExpenses = groupedExpenses
                            
                            HStack {
                                //MARK: PICKER FOR CHARTS
                                ChartsPicker(barGraphPicker: $currentGraphTimeFrame)
                                
                                Spacer()
                                
                                //MARK: TOTAL SPENT LABEL FOR TOP OF BAR CHART
                                totalSpentLabel(for: groupedExpenses)
                            }
                            .padding(.bottom, 25)
                            
                            //MARK: Bar Chart starts here
                            if groupedExpenses.isEmpty {
                                contentUnavailablemessage()
                                    .offset(y: -30)
                            } else {
                                BarChartView(groupedExpenses: groupedExpenses)
                                    .frame(minHeight: 350)
                            }
                            
                            DisclosureGroup("Spending Insights") {
                                VStack {
                                    //MARK: Donut Chart starts here
                                    DonutChartView(categoryTotals: donutChartData, selectedCategory: $selectedCategory, selectedCount: $selectedCount)
                                        .frame(minWidth: 300, minHeight: 300)
                                        .clipped(antialiased: false)
                                        
                                    
                                    Section {
                                        GroupBox {
                                                ForEach(donutChartData) { categorySelected in
                                                    HStack {
                                                        Circle()
                                                            .frame(width: 10, height: 10)
                                                            .foregroundStyle(color(for: categorySelected.category))
                                                        
                                                        Text(categorySelected.category.rawValue)
                                                        
                                                        Spacer()
                                                        
                                                        VStack(alignment: .leading) {
                                                            Text(currencyFormat(value:categorySelected.total))
                                                        }
                                                    }
                                                    
                                                    
                                                }
                                            
                                        }
                                        .padding(.bottom)
                                    } header: {
                                        Text("Top Spending Categories")
                                            .font(.headline)
                                            .fontWeight(.light)
                                    }
                                    
                                }
                                .padding(.top, 25)
                                
                            }
                            .tint(.accentColor)
                            
                        }
                        .listRowSeparator(.hidden, edges: .bottom)
                    //}
                    
                }
                
            }
            .navigationTitle("Summary")
        }
    }
}


#Preview {
    @Previewable @State var selectedCategory: CategoryTotal?
    let preview = previewContainer([Expense.self])
    ChartsView().modelContainer(preview.container)
}


