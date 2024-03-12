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
    var name: String
    var date: Date
    var value: Double
    
    var dateParsed: Date {
        date.description.dateParsed()
    }
    
    var month: String {
        date.formatted(.dateTime.year().month(.wide))
    }
    
    init(name: String, date: Date, value: Double) {
        self.name = name
        self.date = date
        self.value = value
    }
}

struct FormattedDateString {
    let date: Date
    
    init(_ date: Date) {
        self.date = date
    }
    
    var fullMonth: String {
        date.formatted(.dateTime.year().month(.wide))
    }
    
    var shortMonth: String {
        date.formatted(.dateTime.year().month(.wide))
    }
}
