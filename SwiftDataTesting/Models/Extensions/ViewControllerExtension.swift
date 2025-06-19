//
//  ViewControllerExtension.swift
//  SwiftDataExpensesTracker
//
//  Created by Benia Morgan-Ware on 6/13/25.
//

import SwiftUI
import UIKit

extension UIApplication {
    var currentKeyWindow: UIWindow? {
        connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }
    }
    var rootViewController: UIViewController? {
        currentKeyWindow?.rootViewController
    }
}

extension UIViewController {
    func topMostViewController() -> UIViewController {
        if let presentedViewController = presentedViewController {
            return presentedViewController.topMostViewController()
        }
        if let navigationController = self as? UINavigationController {
            return navigationController.visibleViewController?.topMostViewController() ?? self
        }
        if let tabBarController = self as? UITabBarController {
            return tabBarController.selectedViewController?.topMostViewController() ?? self
        }
        return self
    }
}
