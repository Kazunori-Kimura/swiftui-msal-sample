//
//  UIApplication+TopViewController.swift
//  MsalSample
//
//  Created by Kazunori Kimura on 2024/02/01.
//

import UIKit

extension UIApplication {
    static var topViewController: UIViewController? {
        // 'windows' was deprecated in iOS 15.0... と言う警告を消す
        // https://zenn.dev/paraches/articles/windows_was_depricated_in_ios15
        let scenes = UIApplication.shared.connectedScenes
        let window = (scenes.first as? UIWindowScene)?.windows.filter { $0.isKeyWindow }.first
        let rootVC = window?.rootViewController
        return rootVC?.top()
    }
}

private extension UIViewController {
    func top() -> UIViewController {
        if let nav = self as? UINavigationController {
            return nav.visibleViewController?.top() ?? nav
        } else if let tab = self as? UITabBarController {
            return tab.selectedViewController ?? tab
        } else {
            return presentedViewController?.top() ?? self
        }
    }
}
