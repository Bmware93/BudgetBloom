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
                        SectorMark(angle: .value("Category", expense.value),
                                   innerRadius: .ratio(0.5)
                                   //outerRadius: MarkDimension,
                                   //angularInset: 1.0
                        )
                            .foregroundStyle(by: .value("Category", expense.category.rawValue))
                            .cornerRadius(5)
                    }
                }
                .chartLegend(position: .bottomTrailing, alignment: .centerLastTextBaseline)
                .frame(width: 200, height: 200)
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
        .init(name: "The Red Hook", date: .now, value: 24.80, category: .food),
        .init(name: "Parc", date: .now, value: 50.59, category: .food),
        .init(name: "CVS", date: .now, value: 48.60, category: .health),
        .init(name: "Capital One", date: .now, value: 200.00, category: .debt)
    
    ]
}
