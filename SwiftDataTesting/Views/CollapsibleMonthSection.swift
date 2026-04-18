//
//  CollapsibleMonthSection.swift
//  SwiftDataExpensesTracker
//
//  Created by Benia Morgan-Ware on 4/18/26.
//

import SwiftUI
import SwiftData

struct CollapsibleMonthSection: View {
    let month: String
    let expenses: [Expense]
    let totalAmount: Double
    @State private var isExpanded = false
    @Binding var expenseToEdit: Expense?
    let context: ModelContext
    
    var transactionCount: Int {
        expenses.count
    }
    
    var transactionText: String {
        transactionCount == 1 ? "transaction" : "transactions"
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Month Header
            Button {
                withAnimation(.easeInOut(duration: 0.25)) {
                    isExpanded.toggle()
                }
            } label: {
                HStack {
                    Image(systemName: isExpanded ? "chevron.down" : "chevron.right")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.bbDarkPurple)
                        .frame(width: 20)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(month)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.primary)
                        
                        Text("\(transactionCount) \(transactionText)")
                            .font(.system(size: 14))
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    Text(currencyFormat(value: totalAmount))
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.bbDarkPurple)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .buttonStyle(.plain)
            
            // Expanded Content
            if isExpanded {
                VStack(spacing: 8) {
                    ForEach(expenses) { expense in
                        ExpenseCellView(expense: expense)
                            .padding(.horizontal, 16)
                            .onTapGesture {
                                expenseToEdit = expense
                            }
                            .accessibilityAddTraits(.isButton)
                            .contextMenu {
                                Button("Edit", systemImage: "pencil") {
                                    expenseToEdit = expense
                                }
                                
                                Button("Delete", systemImage: "trash", role: .destructive) {
                                    context.delete(expense)
                                }
                            }
                    }
                }
                .padding(.top, 8)
                .transition(.asymmetric(
                    insertion: .opacity.combined(with: .scale(scale: 0.95, anchor: .top)),
                    removal: .opacity.combined(with: .scale(scale: 0.95, anchor: .top))
                ))
                .clipped()
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
    }
}

#Preview {
    @Previewable @State var expenseToEdit: Expense?
    let preview = previewContainer([Expense.self])
    
    CollapsibleMonthSection(
        month: "June 2025",
        expenses: [
            Expense(name: "The Red Hook", date: .now, amount: 12.80, category: .food, expenseDescription: ""),
            Expense(name: "Grocery Store", date: .now, amount: 45.32, category: .groceries, expenseDescription: "")
        ],
        totalAmount: 58.12,
        expenseToEdit: $expenseToEdit,
        context: preview.container.mainContext
    )
    .modelContainer(preview.container)
}