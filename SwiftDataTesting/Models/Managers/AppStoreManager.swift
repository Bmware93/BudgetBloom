//
//  AppStoreManager.swift
//  SwiftDataExpensesTracker
//
//  Created by Benia Morgan-Ware on 6/13/25.
//

import Foundation
import UIKit

class AppStoreManager {
    static let shared = AppStoreManager()
    private let appID = "6737521957"
    private let appName = Bundle.main.displayName ?? "BudgetBloom"
    
    private init() {}
    
    func requestReview() {
        let appStoreURL = "https://apps.apple.com/app/id\(appID)?action=write-review"
        
        guard let url = URL(string: appStoreURL) else {
            print("Invalid App Store URL")
            return
        }
        
        UIApplication.shared.open(url)
    }
    
    func shareApp(from viewController: UIViewController, sourceView: UIView? = nil) {
        let appStoreURL = "https://apps.apple.com/app/id\(appID)"
        
        let shareText = "Check out \(appName)! I've been using it and think you'd like it too."
        let itemsToShare: [Any] = [shareText, appStoreURL]
        
        let activityViewController = UIActivityViewController(
            activityItems: itemsToShare,
            applicationActivities: nil
        )
        
        viewController.present(activityViewController, animated: true)
    
    }
}
