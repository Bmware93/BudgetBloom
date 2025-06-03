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
            , shortTitle: "Week Spend Report"
            , systemImageName: "chart.bar"
        )
        AppShortcut(
            intent: MonthlySpendIntent(),
            phrases: [
                "What's my spending this month in \(.applicationName)?",
                "How much did I spend this month in \(.applicationName)?",
                "\(.applicationName) Monthly spending report"
            ],
            shortTitle: "Month Spend Report",
            systemImageName: "chart.pie"
        )
        AppShortcut(
            intent: YearAmountIntent(),
            phrases: [
                "What's my year to date spending in \(.applicationName)?",
                "How much have I spent this year in \(.applicationName)?",
                "\(.applicationName) Year to date spending report"
            ],
            shortTitle: "YTD Spend Report",
            systemImageName: "chart.line.uptrend.xyaxis"
        )
        
    }
}
