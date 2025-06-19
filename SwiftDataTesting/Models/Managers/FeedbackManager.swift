//
//  FeedbackManager.swift
//  SwiftDataExpensesTracker
//
//  Created by Benia Morgan-Ware on 6/13/25.
//

import Foundation
import UIKit
import MessageUI

class FeedbackManager: NSObject, MFMailComposeViewControllerDelegate {
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
            let appVersion = Bundle.main.appVersion ?? "Unknown"
            let buildNumber = Bundle.main.buildNumber ?? "Unknown"
            let osVersion = device.systemVersion
            let deviceModel = device.model
            
            return """
            App Version: \(appVersion) (\(buildNumber))
            iOS Version: \(osVersion)
            Device: \(deviceModel)
            """
        }

      }
extension FeedbackManager {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        switch result {
        case .cancelled:
            print("Mail cancelled")
        case .saved:
            print("Mail saved")
        case .sent:
            print("Mail sent")
        case .failed:
            print("Mail failed: \(error?.localizedDescription ?? "Unknown error")")
        @unknown default:
            print("Unknown mail result")
        }
        
        controller.dismiss(animated: true, completion: nil)
    }
}

extension Bundle {
    var displayName: String? {
        object(forInfoDictionaryKey: "CFBundleDisplayName") as? String ??
        object(forInfoDictionaryKey: "CFBundleName") as? String
    }
    
    var appVersion: String? {
        object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    }
    
    var buildNumber: String? {
        object(forInfoDictionaryKey: "CFBundleVersion") as? String
    }
}
