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
            return "Sprinkler"
        case let id where id.contains("medium"):
            return "Garden hose"
        case let id where id.contains("large"):
            return "Thunderstorm"
        default:
            return "Tip"
        }
    }
    
    var tipEmoji: String {
        switch id {
        case let id where id.contains("small"):
            return "💦"
        case let id where id.contains("medium"):
            return "🌊"
        case let id where id.contains("large"):
            return "🌩️"
        default:
            return "💝"
        }
    }
}
