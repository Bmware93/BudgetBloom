//
//  SettingsView.swift
//  SwiftDataExpensesTracker
//
//  Created by Benia Morgan-Ware on 1/29/24.
//

import SwiftUI
import SwiftData

struct SettingsView: View {
    @Query var expenses: [Expense]
    @State private var showingShareSheet = false
    @State private var csvFileURL: URL?
    @State private var showingExportError = false
    @State private var exportErrorMessage = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    Section(header: Text("Share")) {
                        Menu {
                            Button("All Transactions") {
                                CSVExportManager.exportFromSwiftUI(expenses: expenses)
                            }
                            Button("Current Month only") {
                                let currentMonthExpenses = getMonthlyExpenseSum(expenses: expenses, for: Date()).elements.first
                                CSVExportManager.exportFromSwiftUI(expenses: currentMonthExpenses?.value.expenses ?? [])
                            }
                            Button("Year to date") {
                                let ytdExpenses = getYTDExpenseSum(expenses: expenses, for: Date()).elements.values
                                CSVExportManager.exportFromSwiftUI(expenses: ytdExpenses.flatMap(\.expenses))
                            }
                        } label: {
                            Label("Export Data", systemImage: "square.and.arrow.up")
                        }
                        .disabled(expenses.isEmpty)
                        
                        Button {
                            shareApp()
                        } label: {
                            VStack(alignment: .leading) {
                                Label("Share", systemImage: "paperplane")
                                
                                HStack {
                                    Text("Have a friend who'd love this app?")
                                        .font(.footnote)
                                }
                                .padding(.leading, 46)
                            }
                            
                        }
                    }
                    Section(header: Text(LocalizedStringResource("Support"))) {
                        NavigationLink {
                            TipJarView()
                        } label: {
                            VStack(alignment:.leading) {
                                Label("Tip Jar", systemImage: "giftcard")
                                
                                HStack {
                                    Text("Support the developer's free side project!")
                                        .font(.footnote)
                                }
                                .padding(.leading, 46)
                            }
                        }
                        .foregroundStyle(.accent)
                        Button {
                            AppStoreManager.shared.requestReview()
                        } label: {
                            VStack(alignment: .leading) {
                                Label("Leave a Review", systemImage: "hand.thumbsup")
                                
                                HStack {
                                    Text("Help others discover this app!")
                                        .font(.footnote)
                                }
                                .padding(.leading, 46)
                            }
                        }
                        //.foregroundStyle(.primary)
                    }
                    Section(header: Text(LocalizedStringResource("Help"))) {
                        Button {
                            sendFeedback()
                        } label: {
                            VStack(alignment: .leading) {
                                Label("Send Feedback", systemImage: "envelope")
                                
                                HStack {
                                    Text("Email thoughts, bugs or questions.")
                                        .font(.footnote)
                                }
                                .padding(.leading, 46)
                            }
                            
                        }
                    }
                }
            }
            .navigationTitle("Menu")
        }
    }
}

private func sendFeedback() {
    guard let rootViewController = UIApplication.shared.rootViewController else {
        return
    }
    let topViewController = rootViewController.topMostViewController()
    FeedbackManager.shared.sendFeedback(from: topViewController)
}

private func shareApp() {
    guard let rootViewController = UIApplication.shared.rootViewController else {
        return
    }
    
    let topViewController = rootViewController.topMostViewController()
    AppStoreManager.shared.shareApp(from: topViewController)
}


#Preview {
    SettingsView()
}
