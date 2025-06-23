//
//  TipOptionRow.swift
//  SwiftDataExpensesTracker
//
//  Created by Benia Morgan-Ware on 6/22/25.
//

import SwiftUI
import StoreKit

struct TipOptionRow: View {
    let product: Product
    let isPurchasing: Bool
    let onPurchase: () async -> Void
    
    var body: some View {
        HStack {
            Text(product.tipEmoji)
                .font(.title2)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(product.tipDescription)
                    .font(.headline)
                
                Text(product.description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Button(action: {
                Task {
                    await onPurchase()
                }
            }) {
                if isPurchasing {
                    ProgressView()
                        .scaleEffect(0.8)
                } else {
                    Text(product.displayPrice)
                        .fontWeight(.semibold)
                }
            }
            .buttonStyle(.borderedProminent)
            .disabled(isPurchasing)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}


//#Preview {
//    TipOptionRow()
//}
