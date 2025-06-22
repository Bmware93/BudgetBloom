//
//  ProductExtensions.swift
//  SwiftDataExpensesTracker
//
//  Created by Benia Morgan-Ware on 6/22/25.
//

import Foundation
import StoreKit

extension Product {
    var tipDescription: String {
        switch id {
        case let id where id.contains("small"):
            return "Small Tip"
        case let id where id.contains("medium"):
            return "Medium Tip"
        case let id where id.contains("large"):
            return "Large Tip"
        default:
            return "Tip"
        }
    }
    
    var tipEmoji: String {
        switch id {
        case let id where id.contains("small"):
            return "💧"
        case let id where id.contains("medium"):
            return "💦"
        case let id where id.contains("large"):
            return "🌊"
        default:
            return "💝"
        }
    }
}
