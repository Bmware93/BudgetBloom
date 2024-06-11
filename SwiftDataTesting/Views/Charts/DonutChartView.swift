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
        Chart(categoryTotals) { item in
            SectorMark(angle: .value("Total Spent",
                                     isAnimating == false ? 0 : item.total ),
                       innerRadius: .ratio(0.5))
            
            .position(by: .value("Category", item.total))
            .foregroundStyle(by: .value("Category", item.category.rawValue))
            .position(by: .value("Value", item.total))
            .cornerRadius(5)
            
        }
        
        .frame(width: 280, height: 250)
        //.chartLegend(alignment:.bottomLeading,spacing: 20)
        .chartForegroundStyleScale(
            range: [Color.DarkBlue, .lightblue, .navyBlue, .brandGreen])
        .animateOnAppear(isAnimating: $isAnimating)
    }
}

#Preview {
    DonutChartView(categoryTotals: [])
}
