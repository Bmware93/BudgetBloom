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
    let groupedExpenses: TransactionGroup
    
    //Getting max amount spent in a month
    //Defaults to 1000 is no values exist
    var maxSpending: Double {
        groupedExpenses.values.map {$0.sum }.max() ?? 1000
    }
    var minSpending: Double {
        groupedExpenses.values.map {$0.sum }.min() ?? 50
    }
    
    var body: some View {
        Chart(groupedExpenses.keys, id: \.self) { month in
            if let group = groupedExpenses[month]  {
                
                BarMark(x: .value("Month", month),
                        y: .value("Total Spent", isAnimating == false ? 50 : group.sum)
                )
                .foregroundStyle(by: .value("Month", month))
                
            }
            
        }
        .frame(minHeight: 200)
        .chartLegend(.hidden)
        .chartForegroundStyleScale(range: [Color.DarkBlue, .brandGreen, .navyBlue, .lightblue])
        .animateOnAppear(isAnimating: $isAnimating)
        
        .chartYScale(domain: 0...maxSpending)
        .padding(.bottom, 20)
        //.offset(y: 20)
        
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
    BarChartView(groupedExpenses: [:])
}
