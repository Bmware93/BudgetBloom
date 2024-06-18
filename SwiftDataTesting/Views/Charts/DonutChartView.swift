//
//  DonutChartView.swift
//  SwiftDataExpensesTracker
//
//  Created by Benia Morgan-Ware on 5/29/24.
//

import SwiftUI
import Charts

struct DonutChartView: View {
    let categoryTotals: [CategoryTotal]
    @State private var isAnimating = false
    
    var body: some View {
        ZStack {
            Chart(categoryTotals) { item in
                SectorMark(
                    angle: .value("Total Spent", isAnimating == false ? 0 : item.total ),
                           innerRadius: .ratio(0.618),
                           angularInset: 1.5
                )
                .position(by: .value("Category", item.total))
                .foregroundStyle(by: .value("Category", item.category.rawValue))
                .cornerRadius(5)
                
            }
            .padding(.bottom)
            //.chartLegend(alignment:.leadingLastTextBaseline)
            .chartForegroundStyleScale(
                range: [Color.DarkBlue, .lightblue, .navyBlue, .brandGreen])
        .animateOnAppear(isAnimating: $isAnimating)
            
            VStack {
                Text("Category")
                Text("Breakdown")
            }
            .padding(.bottom)
            
        }
    }
}

#Preview {
    DonutChartView(categoryTotals: [])
}
