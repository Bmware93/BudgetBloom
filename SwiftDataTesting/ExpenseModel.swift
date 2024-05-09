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
    var name: String
    var date: Date
    var amount: Double
    var category: SpendingCategory
    
    var dateParsed: Date {
        date.description.dateParsed()
    }
    
    var month: String {
     date.formatted(.dateTime.year().month(.wide))
        
    }
     //Short month is the month abbreviated plus the year
     var shortMonth: String {
        let newDate = date.formatted(.dateTime.year().month(.wide))
          
        let abbrevMonth = newDate.prefix(3)
        let year = newDate.suffix(4)
          
          //This is ghetto
         //Find a better way at some point
          return String(abbrevMonth + " " + year)
     }
    
     
     init(name: String, date: Date, amount: Double, category: SpendingCategory = .undefined) {
         self.name = name
         self.date = date
         self.amount = amount
         self.category = category
     }
}

enum SpendingCategory:String, CaseIterable,Identifiable, Codable {
    case housing = "Housing"
    case transportation = "Transportation"
    case utilities = "Utilities"
    case subcription = "Subsciption"
    case clothing = "Clothing"
    case childcare = "Child Care"
    case debt = "Debt"
    case health = "Health/Medical"
    case food = "Food"
    case entertainment = "Entertainment"
    case personal = "Personal Care"
    case misc = "Misc"
    case undefined = "Undefined"
    
    var id: String { rawValue }
}

enum CurrencyCode:String, CaseIterable {
    case USD
    case CAD
    case EUR
}


