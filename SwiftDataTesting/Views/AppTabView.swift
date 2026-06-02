//
//  AppTabView.swift
//  SwiftDataExpensesTracker
//
//  Created by Benia Morgan-Ware on 1/29/24.
//

import SwiftUI
import Foundation

// MARK: - Expense Input Parsing

struct ParsedExpenseInput {
    let amount: Double?
    let merchant: String?
    let category: String?
}

func parseExpenseInput(_ text: String) -> ParsedExpenseInput {
    let cleanedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
    
    // Extract amount
    let amount = extractAmount(from: cleanedText)
    
    // Extract merchant
    let merchant = extractMerchant(from: cleanedText)
    
    // Extract/map category based on merchant and keywords
    let category = mapCategory(from: cleanedText, merchant: merchant)
    
    return ParsedExpenseInput(amount: amount, merchant: merchant, category: category)
}

private func extractAmount(from text: String) -> Double? {
    // Regex patterns for currency amounts
    let patterns = [
        "\\$([0-9]+(?:\\.[0-9]{1,2})?)", // $25.99 or $25
        "([0-9]+(?:\\.[0-9]{1,2})?)\\s*(?:dollars?|bucks?)", // 25.99 dollars
        "(?:^|\\s)([0-9]+(?:\\.[0-9]{1,2})?)(?=\\s|$)" // bare numbers like 25.99
    ]
    
    for pattern in patterns {
        if let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive) {
            let range = NSRange(text.startIndex..., in: text)
            if let match = regex.firstMatch(in: text, options: [], range: range) {
                let matchRange = Range(match.range(at: 1), in: text) ?? Range(match.range(at: 0), in: text)
                if let matchRange = matchRange {
                    let amountString = String(text[matchRange]).replacingOccurrences(of: "$", with: "")
                    return Double(amountString)
                }
            }
        }
    }
    
    return nil
}

private func extractMerchant(from text: String) -> String? {
    // Look for merchants after prepositions like "at" or "from"
    let patterns = [
        "(?:at|from|to)\\s+([A-Z][a-zA-Z\\s&'-]+?)(?:\\s|$|[,.!?])", // "at Starbucks" or "from Target"
        "(?:paid|spent)\\s+.*?(?:at|from)\\s+([A-Z][a-zA-Z\\s&'-]+?)(?:\\s|$|[,.!?])" // "paid 5.99 at Starbucks"
    ]
    
    for pattern in patterns {
        if let regex = try? NSRegularExpression(pattern: pattern, options: []) {
            let range = NSRange(text.startIndex..., in: text)
            if let match = regex.firstMatch(in: text, options: [], range: range) {
                if let matchRange = Range(match.range(at: 1), in: text) {
                    return String(text[matchRange]).trimmingCharacters(in: .whitespacesAndNewlines)
                }
            }
        }
    }
    
    // Fallback: look for capitalized words that might be merchants
    let words = text.components(separatedBy: .whitespacesAndNewlines)
    for word in words {
        if word.count > 2 && word.first?.isUppercase == true && !["At", "From", "To", "The", "And", "Or", "For", "With"].contains(word) {
            return word
        }
    }
    
    return nil
}

private func mapCategory(from text: String, merchant: String?) -> String? {
    let lowercasedText = text.lowercased()
    let merchantLower = merchant?.lowercased() ?? ""
    
    // Category mapping based on keywords and known merchants
    let categoryMappings: [(keywords: [String], category: String)] = [
        // Food & Dining
        (["starbucks", "coffee", "cafe", "restaurant", "food", "lunch", "dinner", "breakfast", "eat", "meal", "pizza", "burger", "sandwich"], "Dining Out"),
        (["grocery", "market", "supermarket", "walmart", "target", "costco", "kroger", "safeway", "whole foods", "trader joe"], "Groceries"),
        
        // Transportation
        (["gas", "fuel", "shell", "exxon", "chevron", "bp", "uber", "lyft", "taxi", "parking", "metro", "subway", "bus"], "Transportation"),
        
        // Shopping & Retail
        (["amazon", "ebay", "store", "shop", "retail", "mall", "clothing", "clothes", "shirt", "pants", "shoes"], "Clothing"),
        (["pharmacy", "cvs", "walgreens", "medicine", "prescription", "drug", "health"], "Health/Medical"),
        
        // Entertainment
        (["movie", "cinema", "theater", "netflix", "spotify", "hulu", "disney", "entertainment", "game", "concert"], "Entertainment"),
        (["gym", "fitness", "yoga", "spa", "massage", "personal care"], "Personal Care"),
        
        // Utilities & Services
        (["electric", "water", "internet", "phone", "utility", "bill", "subscription"], "Utilities"),
        (["rent", "mortgage", "housing", "apartment", "home"], "Housing"),
        
        // Pets
        (["pet", "dog", "cat", "vet", "veterinary", "petco", "petsmart"], "Pet Care")
    ]
    
    // Check text and merchant against category mappings
    for mapping in categoryMappings {
        for keyword in mapping.keywords {
            if lowercasedText.contains(keyword) || merchantLower.contains(keyword) {
                return mapping.category
            }
        }
    }
    
    return nil
}

struct AppTabView: View {
    
    var body: some View {
        //Repeating onAppear modifier for haptic feedback on each tab item.. Is there a better way?
        
        TabView {
            ContentView()
                .tabItem {
                    Label("Spending", systemImage: "creditcard")
                }
                .onAppear {
                    UIImpactFeedbackGenerator(style: .soft).impactOccurred()
                }
            
            ChartsView()
                .tabItem {
                    Label("Summary", systemImage: "chart.bar.xaxis")
                }
                .onAppear {
                    UIImpactFeedbackGenerator(style: .soft).impactOccurred()
                }
          
            SettingsView()
                .tabItem {
                    Label("More", systemImage: "ellipsis")
                }
                .onAppear {
                    UIImpactFeedbackGenerator(style: .soft).impactOccurred()
                }
            }
        
        }
    }

#Preview {
    let preview = previewContainer([Expense.self])
    return AppTabView().modelContainer(preview.container)
}
