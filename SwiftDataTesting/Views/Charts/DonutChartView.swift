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
    @State private var selectedCategory: CategoryTotal?
    @State private var selectedCount: Double?

    
    var body: some View {
        ZStack {
            Chart(categoryTotals) { item in
                SectorMark(
                    angle: .value("Total Spent", isAnimating == false ? 0 : item.total ),
                           innerRadius: .ratio(0.618),
                           outerRadius: selectedCategory?.category == item.category ? 175 : 150,
                           angularInset: 1.5
                )
                .position(by: .value("Category", item.total))
                .foregroundStyle(by: .value("Category", item.category.rawValue))
                .cornerRadius(5)
                .opacity(item.category == selectedCategory?.category ? 1.0 : 0.3)
                
            }
            .padding(.bottom)
            .chartLegend(.hidden)
            .chartAngleSelection(value: $selectedCount)
            .chartForegroundStyleScale(
                range: [Color.DarkBlue, .lightblue, .navyBlue, .brandGreen])
            .animateOnAppear(isAnimating: $isAnimating)
            .onChange(of: selectedCount) { oldValue, newValue in
                if let newValue {
                    withAnimation(.bouncy) {
                        getSelectedCategory(value: newValue)
                    }
                }
            }
            
        
            VStack {
                Text(selectedCategory?.category.rawValue ?? "Select a section")
                    .bold()
                if let selectedCategory {
                    Text(currencyFormat(value:selectedCategory.total))
                }
                
            }
            .padding(.bottom)
            
        }
       
    }
    private func getSelectedCategory(value: Double) {
        var cumulativeTotal = 0.0
        _ = categoryTotals.first { category in
            cumulativeTotal += category.total
            if value <= cumulativeTotal {
                selectedCategory = category
                return true
            }
            return false
        }
    }
    
}



#Preview {
    DonutChartView(categoryTotals: [])
}
