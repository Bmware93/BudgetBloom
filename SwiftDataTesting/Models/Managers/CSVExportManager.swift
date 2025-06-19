//
//  CSVExportManager.swift
//  SwiftDataExpensesTracker
//
//  Created by Benia Morgan-Ware on 6/5/25.
//

import Foundation
import UIKit

class CSVExportManager {
    
    @MainActor
    static func exportCSV(expenses: [Expense], from viewController: UIViewController) {
        let csvContent = try! generateCSVFromExpenses(expenses: expenses)
        
        let fileName = "BBExpenses_\(DateFormatter.exportDateFormatter.string(from: Date())).csv"
        let tempUrl = createTempFile(Content: csvContent, fileName: fileName)
        
        guard let fileUrl = tempUrl else {
            showAlert(message: "Failed to create CSV File", from: viewController)
            return
        }
        presentShareSheet(fileURL: fileUrl, from: viewController)
    }
    
    static func exportFromSwiftUI(expenses: [Expense]) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = windowScene.windows.first?.rootViewController else {
            print("Could not find root view controller")
            return
        }
        Task {
            await exportCSV(expenses: expenses, from: rootViewController)
        }
    }
    
    static func createTempFile(Content content: String, fileName: String) -> URL? {
        let tempDirectory = FileManager.default.temporaryDirectory
        let fileURL = tempDirectory.appendingPathComponent(fileName)
        
        do {
            try content.write(to: fileURL, atomically: true, encoding: .utf8)
            return fileURL
        } catch {
            print("error creating temporary file")
            return nil
        }
    }
    
    private static func presentShareSheet(fileURL: URL, from viewController: UIViewController) {
        let activityViewController = UIActivityViewController(
            activityItems: [fileURL],
            applicationActivities: nil
        )
        
        viewController.present(activityViewController, animated: true)
    }
    
    private static func showAlert(message: String, from viewController: UIViewController) {
        let alert = UIAlertController(title: "Export Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        viewController.present(alert, animated: true)
    }

}


