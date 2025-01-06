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
    let chartColors = [Color.brandDarkBlue, .lightblue, .navyBlue, .brandGreen]
    @State private var selectedCount: Double?
    @State var selectedCategory: CategoryTotal?
    
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
        let sortedCategories = topCategoryTotals.map { $0.category }.sorted(by: { $0.rawValue < $1.rawValue })
        if let index = sortedCategories.firstIndex(of: category) {
            return chartColors[index % chartColors.count]
        }
        return .gray
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
                    
                    VStack {
                        Form {
                            
                            let groupedExpenses = getMonthlyExpenseSum()
                            
                            HStack {
                                //MARK: PICKER FOR CHARTS
                                ChartsPicker()
                                
                                Spacer()
                                
                                //MARK: TOTAL SPENT LABEL FOR TOP OF BAR CHART
                                totalSpentLabel(for: groupedExpenses)
                            }
                            .padding(.bottom, 25)
                            
                            //MARK: Bar Chart starts here
                            BarChartView(groupedExpenses: groupedExpenses)
                                .frame(minHeight: 230)
                            
                            
                            DisclosureGroup("Spending Insights") {
                                VStack {
                                    //MARK: Donut Chart starts here
                                    DonutChartView(categoryTotals: topCategoryTotals, selectedCategory: $selectedCategory, selectedCount: $selectedCount)
                                        .frame(minWidth: 280, minHeight: 280)
                                        .onChange(of: selectedCount) { oldValue, newValue in
                                            print("Old Value: \(String(describing: oldValue)), New Value: \(String(describing: newValue))")
                                            guard let newValue  else { return }
                                                    withAnimation(.bouncy) {
                                                        selectedCategory = getSelectedCategory(value: newValue)
                                                    }
                                            
                                        }

                                    
                                    GroupBox {
                                        VStack(alignment: .leading) {
                                            ForEach(topCategoryTotals) { categorySelected in
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
                                        
                                    }
                                    .padding(.bottom)
                                }
                                .padding(.top, 25)

                            }
                            .tint(.brandDarkBlue)
                            
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
    @Previewable @State var selectedCategory: CategoryTotal?
    let preview = previewContainer([Expense.self])
    ChartsView().modelContainer(preview.container)
}


