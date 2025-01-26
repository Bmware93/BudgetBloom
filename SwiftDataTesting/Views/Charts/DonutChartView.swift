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
    @Binding var selectedCategory: CategoryTotal?
    @Binding var selectedCount: Double?
    @State private var currentCategory: CategoryTotal? = nil

    func getSelectedCategory(value: Double) -> CategoryTotal?{
        var cumulativeTotal = 0.0
       return categoryTotals.first { category in
            cumulativeTotal += category.total
            if value <= cumulativeTotal {
                selectedCategory = category
                return true
            }
            return false
        }
    }
    
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
                range: [Color.bbDarkPurple, .bbLGreen, .bbLPurple, .bloomPink])
            .animateOnAppear(isAnimating: $isAnimating)
            .onAppear {
                print("Selected Count on Appear: \(String(describing: selectedCount))")
            }
            .onChange(of: selectedCount) { oldValue, newValue in
                print("Old Value: \(String(describing: oldValue)), New Value: \(String(describing: newValue))")
                guard let newValue  else { return }
                        withAnimation(.bouncy) {
                            selectedCategory = getSelectedCategory(value: newValue)
                        }
                
            }
        
            VStack {
                Text(selectedCategory?.category.rawValue ?? "Tap a section")
                    .bold()
                if let selectedCategory {
                    Text(currencyFormat(value:selectedCategory.total))
                }
                
            }
            .padding(.bottom)
            
        }
       
    }
  
    
}



#Preview {
    @Previewable @State var selectedCategory: CategoryTotal?
    @Previewable @State var selectedCount: Double? = 0.0
    DonutChartView(categoryTotals: [
        CategoryTotal(category: .housing, total: 1200.00),
        CategoryTotal(category: .transportation, total: 250.50),
        CategoryTotal(category: .utilities, total: 150.75),
        CategoryTotal(category: .subscription, total: 50.00),
        CategoryTotal(category: .clothing, total: 75.00),
        CategoryTotal(category: .childcare, total: 300.00),
        CategoryTotal(category: .debt, total: 200.00),
        CategoryTotal(category: .health, total: 180.25),
        CategoryTotal(category: .food, total: 400.50),
        CategoryTotal(category: .entertainment, total: 120.00),
        CategoryTotal(category: .personal, total: 60.00),
        CategoryTotal(category: .misc, total: 40.00)], selectedCategory: $selectedCategory, selectedCount: $selectedCount)
    .frame(minWidth: 280, minHeight: 280)
}
