//
//  CategoryData.swift
//  SwiftDataExpensesTracker
//
//  Created by Benia Morgan-Ware on 5/13/24.
//

import Foundation

/* Charts framework expects that all data being passed in conforms to identfiable To ensure that each data point is identfiable, it has been wrapped in a small struct that conforms to identifiable
 */
struct CategoryTotal: Identifiable {
    var id: String { category.rawValue }
    var category: SpendingCategory
    var total: Double
    
}





