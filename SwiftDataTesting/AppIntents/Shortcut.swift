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
            shortTitle: "Daily Spend Report",
            systemImageName: "dollarsign.circle"
        )
        AppShortcut(
            intent: WeeklyAmountIntent(),
            phrases: [
                "What's my spending this week in \(.applicationName)?",
                "How much did I spend this week in \(.applicationName)?",
                "\(.applicationName) Weekly spending report"
            ]
            , shortTitle: "Weekly Spend Report"
            , systemImageName: "chart.bar.fill"
        )
        AppShortcut(
            intent: MonthlySpendIntent(),
            phrases: [
                "What's my spending this month in \(.applicationName)?",
                "How much did I spend this month in \(.applicationName)?",
                "\(.applicationName) Monthly spending report"
            ],
            shortTitle: "Monthly Spending Report",
            systemImageName: "banknote"
        )
        
    }
}
