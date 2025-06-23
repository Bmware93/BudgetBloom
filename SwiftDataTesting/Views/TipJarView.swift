//
//  TipJarView.swift
//  SwiftDataExpensesTracker
//
//  Created by Benia Morgan-Ware on 6/22/25.
//

import SwiftUI

import SwiftUI
import StoreKit

struct TipJarView: View {
    @StateObject private var tipJarManager = TipJarManager.shared
    @State private var showingThankYouAlert = false
    @State private var isPurchasing = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                
                // Header starts
                VStack(spacing: 12) {
                    Image(systemName: "drop.fill")
                        .font(.system(size: 50))
                        .foregroundColor(.teal)
                    
                    Text("Water the Bloom")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("Help BudgetBloom blossom by purchasing a tip! Your tip supports development and keeps the garden green.")
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.secondary)
                        .padding(.horizontal)
                }
                .padding(.top)
                
                Spacer()
                
             
                if tipJarManager.isLoading {
                    ProgressView("Loading tip options...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if tipJarManager.products.isEmpty {
                    VStack(spacing: 16) {
                        
                        ContentUnavailableView {
                            Label("Tip Options Unavailable", systemImage: "exclamationmark.triangle")
                                .symbolRenderingMode(.multicolor)
                        }
                        description: {
                            Text(LocalizedStringResource("Please check your internet connection and try again."))
                        }  actions: {
                            Button("Retry") {
                                Task {
                                    await tipJarManager.loadProducts()
                                }
                            }
                            .buttonStyle(.bordered)
                        }
                    }
                    .padding()
                    .offset(y: -30)
                } else {
                    LazyVStack(spacing: 12) {
                        ForEach(tipJarManager.products, id: \.id) { product in
                            TipOptionRow(
                                product: product,
                                isPurchasing: isPurchasing
                            ) {
                                await purchaseProduct(product)
                            }
                        }
                    }
        
                }
                
                Spacer()
                
                // Footer
                Text("Tips are one-time purchases and help support the development of new features.")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .padding(.bottom)
            }
            .navigationTitle("Tip Jar")
            .navigationBarTitleDisplayMode(.inline)
            .alert("Thank You! 🫶🏾", isPresented: $showingThankYouAlert) {
                Button("You're Welcome!") { }
            } message: {
                Text("Your support means the world to me and helps keep BudgetBloom growing!")
            }
            .alert("Error", isPresented: .constant(tipJarManager.errorMessage != nil)) {
                Button("OK") {
                    tipJarManager.errorMessage = nil
                }
            } message: {
                if let errorMessage = tipJarManager.errorMessage {
                    Text(errorMessage)
                }
            }
        }
    }
    
    private func purchaseProduct(_ product: Product) async {
        isPurchasing = true
        await tipJarManager.purchase(product)
        isPurchasing = false
        
        // Show thank you alert if purchase was successful
        if tipJarManager.errorMessage == nil {
            showingThankYouAlert = true
        }
    }
}

#Preview {
    TipJarView()
}
