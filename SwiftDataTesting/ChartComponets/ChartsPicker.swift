//
//  ChartsPicker.swift
//  SwiftDataExpensesTracker
//
//  Created by Benia Morgan-Ware on 5/29/24.
//

import SwiftUI

struct ChartsPicker: View {
    @Binding var barGraphPicker: TimePeriods

    var body: some View {
        Menu {
            ForEach(TimePeriods.allCases, id: \.self) { option in
                Button {
                    self.barGraphPicker = option
                } label: {
                    Text(option.rawValue)
                }
                
            }
            
        } label: {
            Text(barGraphPicker.rawValue)
                .font(.system(size: 18))
            Image(systemName: "chevron.up.chevron.down")
                .font(.caption)
        }
        .foregroundStyle(.primary)
    }
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

#Preview {
    @Previewable @State var timePeriod: TimePeriods = .day
    ChartsPicker(barGraphPicker: $timePeriod)
}
