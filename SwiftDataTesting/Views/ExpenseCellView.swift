//
//  ExpenseCellView.swift
//  SwiftDataExpensesTracker
//
//  Created by Benia Morgan-Ware on 1/4/24.
//

import SwiftUI
import SwiftData

struct ExpenseCellView: View {
    let expense: Expense
    
    var body: some View {
        HStack(spacing: 16) {
            // Category icon with colored background
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(categoryColor)
                    .frame(width: 44, height: 44)
                
                Image(systemName: categoryIcon)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(.white)
            }
            
            // Expense details
            VStack(alignment: .leading, spacing: 2) {
                Text(expense.name)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.primary)
                    .lineLimit(1)
                
                Text(expense.date, format: .dateTime.month(.abbreviated).day())
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            // Amount
            Text(currencyFormat(value: expense.amount))
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.primary)
        }
        .padding(.vertical, 8)
    }
    
    // MARK: - Category Styling
    private var categoryColor: Color {
        switch expense.category {
        case .food, .groceries:
            return .bbDarkPurple
        case .transportation, .travel:
            return .bbDarkGreen
        case .entertainment:
            return .bloomPink
        case .health:
            return .bbLPurple
        case .clothing:
            return .bbLGreen
        case .housing, .utilities:
            return .bbDarkGreen
        case .education:
            return .bbDarkPurple
        case .business:
            return .bbLGreen
        case .subscription:
            return .bloomPink
        case .personal:
            return .bbLPurple
        case .pet:
            return .bbLGreen
        case .charity:
            return .bloomPink
        case .saving:
            return .bbDarkGreen
        case .gifts:
            return .bbLPurple
        case .maintenance:
            return .bbDarkGreen
        case .insurance:
            return .bbDarkPurple
        case .investments:
            return .bbLGreen
        case .debt:
            return .bbLPurple
        case .childcare:
            return .bloomPink
        case .toiletries:
            return .bbLPurple
        case .misc:
            return .bbDarkPurple
        case .undefined:
            return .bbDarkPurple
        }
    }
    
    private var categoryIcon: String {
        switch expense.category {
        case .food:
            return "fork.knife"
        case .groceries:
            return "cart"
        case .transportation:
            return "car"
        case .travel:
            return "airplane"
        case .entertainment:
            return "tv"
        case .health:
            return "cross"
        case .clothing:
            return "tshirt"
        case .housing:
            return "house"
        case .utilities:
            return "bolt"
        case .education:
            return "book"
        case .business:
            return "briefcase"
        case .subscription:
            return "rectangle.stack"
        case .personal:
            return "person"
        case .pet:
            return "pawprint"
        case .charity:
            return "heart"
        case .saving:
            return "banknote"
        case .gifts:
            return "gift"
        case .maintenance:
            return "wrench"
        case .insurance:
            return "shield"
        case .investments:
            return "chart.line.uptrend.xyaxis"
        case .debt:
            return "creditcard"
        case .childcare:
            return "figure.2.and.child.holdinghands"
        case .toiletries:
            return "drop"
        case .misc:
            return "ellipsis"
        case .undefined:
            return "questionmark"
        }
    }
}

#Preview {
    let preview = previewContainer([Expense.self])
    ExpenseCellView(expense: Expense(name: "The Red Hook", date: .now, amount: 12.80, category: .food, expenseDescription: "")).modelContainer(preview.container)
}
