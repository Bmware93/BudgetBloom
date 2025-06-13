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
    
    private init() {}
    
    func requestReview() {
        let appStoreURL = "https://apps.apple.com/app/id\(appID)?action=write-review"
        
        guard let url = URL(string: appStoreURL) else {
            print("Invalid App Store URL")
            return
        }
        
        UIApplication.shared.open(url)
    }
    
    func shareApp() {
        let appStoreURL = "https://apps.apple.com/app/id\(appID)"
        
        guard let url = URL(string: appStoreURL) else {
            print("Invalid App Store URL")
            return
        }
        
        UIApplication.shared.open(url)
    }
}
