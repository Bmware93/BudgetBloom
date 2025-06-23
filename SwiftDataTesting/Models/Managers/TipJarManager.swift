//
//  TipJarManager.swift
//  SwiftDataExpensesTracker
//
//  Created by Benia Morgan-Ware on 6/19/25.
//

import Foundation
import StoreKit

@MainActor
class TipJarManager: ObservableObject {
    static let shared = TipJarManager()
    
    @Published var products: [Product] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let tipProductIDs = [
        "budgetBloom.tip.small",
        "budgetBloom.tip.medium",
        "budgetBloom.tip.large"
    ]
    private init() {
        Task {
            await loadProducts()
            await listenForTransactions()
        }
    }
    func loadProducts() async {
        isLoading = true
        errorMessage = nil
        do {
            let products = try await Product.products(for: tipProductIDs)
            self.products = products.sorted { $0.price < $1.price }
        } catch {
            errorMessage = "Failed to load tip options: \(error.localizedDescription)"
            print("Failed to load products: \(error)")
        }
        
        isLoading = false
    }
    func purchase(_ product: Product) async {
        do {
            let result = try await product.purchase()
            
            switch result {
            case .success(let verification):
                
                switch verification {
                case .verified(let transaction):
                    // Transaction is verified, finish it
                    await transaction.finish()
                    
                    // Show thank you message
                    await showThankYouAlert()
                    
                case .unverified(let transaction, let error):
                    // Transaction failed verification
                    print("Transaction failed verification: \(error)")
                    errorMessage = "Purchase verification failed"
                    await transaction.finish()
                }
                
            case .userCancelled:
                print("User cancelled purchase")
                
            case .pending:
                print("Purchase pending approval")
                
            @unknown default:
                print("Unknown purchase result")
            }
        } catch {
            errorMessage = "Purchase failed: \(error.localizedDescription)"
            print("Purchase failed: \(error)")
        }
    }
    
    private func listenForTransactions() async {
        // Listen for transactions that happen outside the app
        for await result in Transaction.updates {
            switch result {
            case .verified(let transaction):
                await transaction.finish()
            case .unverified(let transaction, let error):
                print("Unverified transaction: \(error)")
                await transaction.finish()
            }
        }
    }
    
    private func showThankYouAlert() async {
        // To be handled in the UI
    }
    
    func formatPrice(for product: Product) -> String {
        return product.displayPrice
    }
    
}
