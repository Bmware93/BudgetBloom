//
//  Expense.swift
//  SwiftDataTesting
//
//  Created by Benia Morgan-Ware on 11/28/23.
//

import Foundation
import SwiftData
import Collections

/* Using an ordered dictionary from swift collections
 so expenses grouped by the month keep consistsnt order in content view */
//the typealias is used as another way for me to refer to my expense object but as a group of expenses
typealias TransactionGroup = OrderedDictionary<String, (expenses: [Expense], sum: Double)>

@Model
 class Expense {
    //var accountId: String
    var name: String = ""
    var date: Date = Date()
    var amount: Double = 0.00
    var category: ExpenseCategory = ExpenseCategory.undefined
    var expenseDescription: String = ""
     
    //Computed Properties
    // Note: This property seems unused and has an undefined method
    // Consider removing or implementing properly
    // var dateParsed: Date { date }
    
    var month: String {
     date.formatted(.dateTime.year().month(.wide))
        
    }
     //Short month is the month abbreviated plus the year  
     var shortMonth: String {
         date.formatted(.dateTime.month(.abbreviated).year())
     }
     
     // Validation computed property - good for demonstrating business logic
     var isValid: Bool {
         !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && amount > 0
     }
     
     // Additional useful computed properties for analytics
     var yearMonth: String {
         date.formatted(.dateTime.year().month(.wide))
     }
     
     init(name: String = "", date: Date = Date(), amount: Double = 0.00, category: ExpenseCategory = .undefined, expenseDescription: String = "") {
         self.name = name
         self.date = date
         self.amount = amount
         self.category = category
         self.expenseDescription = expenseDescription
     }
}

enum ExpenseCategory:String, CaseIterable,Identifiable, Codable {
    case housing = "Housing"
    case toiletries = "Toiletries"
    case transportation = "Transportation"
    case travel = "Travel/Vacation"
    case utilities = "Utilities"
    case subscription = "Subscription"
    case clothing = "Clothing"
    case childcare = "Child Care"
    case debt = "Debt"
    case health = "Health/Medical"
    case groceries = "Groceries"
    case food = "Dining Out"
    case entertainment = "Entertainment"
    case personal = "Personal Care"
    case pet = "Pet Care"
    case charity = "Giving/Charity"
    case saving = "Savings"
    case education = "Education"
    case gifts = "Gifts"
    case maintenance = "Home Maintenance"
    case insurance = "Insurance"
    case business = "Business"
    case investments = "Investments"
    case misc = "Misc"
    case undefined = "Undefined"
    
    var id: String { rawValue }
}

func currencyFormat(value: Double) -> String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    formatter.locale = .current // Adjust if you want a specific locale
    return formatter.string(from: NSNumber(value: value)) ?? "$\(value)"
}

enum CurrencyCode:String, CaseIterable {
    case USD
    case CAD
    case EUR
}


