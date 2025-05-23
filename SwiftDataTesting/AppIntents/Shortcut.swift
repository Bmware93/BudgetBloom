//
//  Shortcut.swift
//  SwiftDataExpensesTracker
//
//  Created by Benia Morgan-Ware on 3/4/25.
//

import Foundation
import AppIntents

struct ExpenseAppShortcuts: AppShortcutsProvider {
    static let shortcutTileColor: ShortcutTileColor = .purple
    
    static var appShortcuts: [AppShortcut] {
            AppShortcut(
                intent: GetAmountSpentIntent(),
                phrases: [
                    "How much have I spent today in \(.applicationName)?",
                    "Check my spending for today in \(.applicationName)"
                ],
                shortTitle: "Check My Spending",
                systemImageName: "dollarsign.circle"
            )
        
    }
}
