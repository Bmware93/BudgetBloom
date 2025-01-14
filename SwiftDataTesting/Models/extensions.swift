//
//  extensions.swift
//  SwiftDataExpensesTracker
//
//  Created by Benia Morgan-Ware on 1/2/24.
//

import Foundation
import SwiftUI

extension DateFormatter {
    static let allNumericUSA: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        
        return formatter
    }()
}

extension String {
    func dateParsed() -> Date {
        guard let parsedDate = DateFormatter.allNumericUSA.date(from: self) else { return Date() }
        
        return parsedDate
    }
}

extension Color {
    static let bbDarkPurple = Color.bbPurple
    static let bbLPurple = Color.bbLightPurple
    static let bbDarkGreen = Color.bbGreen
    static let bbLGreen = Color.bbLightGreen
    static let bloomPink = Color.bbPink
}

//MARK: Animation used for Charts
struct AnimateOnAppear: ViewModifier {
    @Binding var isAnimating: Bool
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                withAnimation {
                    isAnimating = true
                }
            }
            .onDisappear {
                isAnimating = false
            }
    }
}

extension View {
    func animateOnAppear(isAnimating: Binding<Bool>) -> some View {
        modifier(AnimateOnAppear(isAnimating: isAnimating))
    }
}
