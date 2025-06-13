//
//  FeedbackManager.swift
//  SwiftDataExpensesTracker
//
//  Created by Benia Morgan-Ware on 6/13/25.
//

import Foundation
import UIKit
import MessageUI

class FeedbackManager:NSObject, MFMailComposeViewControllerDelegate {
    static let shared = FeedbackManager()
    
    private override init() {}
    
    private let feedbackEmail = "bmware.dev@gmail.com"
    private let appName = Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String ?? "BudgetBloom"
    
    
    func sendFeedback(from viewController: UIViewController) {
            if MFMailComposeViewController.canSendMail() {
                presentMailComposer(from: viewController)
            } else {
                openMailAppWithFallback()
            }
        }
        
        private func presentMailComposer(from viewController: UIViewController) {
            let mailComposer = MFMailComposeViewController()
            mailComposer.mailComposeDelegate = self
            mailComposer.setToRecipients([feedbackEmail])
            mailComposer.setSubject("\(appName) - Feedback")
            
            let deviceInfo = getDeviceInfo()
            let messageBody = """
            
            
            ---
            Device Information:
            \(deviceInfo)
            """
            
            mailComposer.setMessageBody(messageBody, isHTML: false)
            
            viewController.present(mailComposer, animated: true)
        }
        
        private func openMailAppWithFallback() {
            let deviceInfo = getDeviceInfo().addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            let subject = "\(appName) - Feedback".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            let body = """
            
            
            ---
            Device Information:
            \(deviceInfo)
            """.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            
            let mailtoString = "mailto:\(feedbackEmail)?subject=\(subject)&body=\(body)"
            
            if let mailtoURL = URL(string: mailtoString) {
                UIApplication.shared.open(mailtoURL)
            }
        }
        
        private func getDeviceInfo() -> String {
            let device = UIDevice.current
            let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
            let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "Unknown"
            let osVersion = device.systemVersion
            let deviceModel = device.model
            
            return """
            App Version: \(appVersion) (\(buildNumber))
            iOS Version: \(osVersion)
            Device: \(deviceModel)
            """
        }

      }
