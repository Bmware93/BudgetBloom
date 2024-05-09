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
                                    Text(String(format: "$%.2f", groupedExpenses.values.reduce(0){ $0 + $1.sum }))
                                        .padding(.bottom)
                                        .font(.headline)
                                        .bold()
                                    
                                    Text("Total Spent")
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                    
                                }
                            }
                            .padding(.bottom, 25)
                            
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
                            .chartYScale(domain: 50...1000)
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
//                                    HStack {
//                                        Text("Daily Average")
//                                            .padding(.trailing)
//                                        Spacer()
//                                        Text("$238.85")
//                                            .bold()
//                                    }
                                    //MARK: Donut Chart starts here
                                    Chart(expenses) { expense in
                                            SectorMark(angle: .value("Total Spent",
                                                                     donutGraphIsAnimating == false ? 0 : expense.amount ),
                                                       innerRadius: .ratio(0.5))
                                            
                                            .foregroundStyle(by: .value("Category", expense.category.rawValue))
                                            .position(by: .value("Category", expense.category.rawValue ))
                                            
                                                .cornerRadius(5)
                                            
                                    }
                                    .frame(width: 270, height: 250)
                                    .chartLegend(spacing: 20)
                                    .chartForegroundStyleScale(
                                        range: [Color.DarkBlue, .lightblue, .navyBlue, .brandGreen])
                                    .onAppear {
                                        withAnimation(.smooth) {
                                            donutGraphIsAnimating = true
                                        }
                                        
                                        
                                    }
                                    .onDisappear {
                                        donutGraphIsAnimating = false
                                    }
                                    
                              
//                                    Text("Great! You didn't exceed your daily average threshold of $250.")
//                                        .font(.subheadline)
//                                        .foregroundStyle(.secondary)
//                                        .padding(.trailing, 40)
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


#Preview {
    let preview = previewContainer([Expense.self])
    return ChartsView().modelContainer(preview.container)
}
