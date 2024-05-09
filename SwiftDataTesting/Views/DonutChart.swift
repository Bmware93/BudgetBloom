//
//  DonutChart.swift
//  SwiftDataExpensesTracker
//
//  Created by Benia Morgan-Ware on 4/9/24.
//

import SwiftUI
import Charts

struct DonutChart: View {
    var body: some View {
        NavigationStack {
            VStack {
                Chart {
                    ForEach(MockData.expenses){ expense in
                        SectorMark(angle: .value("Category", expense.amount),
                                   innerRadius: .ratio(0.5)
                                   //outerRadius: MarkDimension,
                                   //angularInset: 1.0
                        )
                        .position(by: .value("Category", expense.category.rawValue), span: .automatic)
                            .foregroundStyle(by: .value("Category", expense.category.rawValue ))
                            
                            .cornerRadius(5)
                    }
                }
                .chartLegend()
                .frame(width: 300, height: 300)
            }
            .padding()
            //.navigationTitle("Spending")
        }
    }
}

#Preview {
    let preview = previewContainer([Expense.self])
    return DonutChart().modelContainer(preview.container)
}

struct MockData {
    static var expenses: [Expense] = [
        .init(name: "The Red Hook", date: .now, amount: 24.80, category: .food),
        .init(name: "Parc", date: .now, amount: 50.59, category: .food),
        .init(name: "CVS", date: .now, amount: 48.60, category: .health),
        .init(name: "Capital One", date: .now, amount: 200.00, category: .debt),
        .init(name: "McDonalds", date: .now, amount: 70.20, category: .food)
    
    ]
}
