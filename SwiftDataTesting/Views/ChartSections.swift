//
//  ChartSections.swift
//  SwiftDataExpensesTracker
//
//  Created by Benia Morgan-Ware on 4/10/24.
//

import SwiftUI
import Charts

struct ChartSections: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 25)
            .fill(.gray)
            //.opacity()
            .frame(width: 360, height: 400)
            .overlay{
                DonutChart()
            }
    }
    
        
}

#Preview {
    let preview = previewContainer([Expense.self])
    return ChartSections().modelContainer(preview.container)
}
