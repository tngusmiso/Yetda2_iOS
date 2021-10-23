//
//  YetdaNavigationBar.swift
//  Yetda2_iOS
//
//  Created by 임수현 on 2021/10/02.
//

import UIKit

class YetdaNavigationBar {
    private static var backgroundColor: UIColor = .clear
    private static var backButtonColor: UIColor = .veryLightPink
    private static let skipTextColor: UIColor = .blueGrey
    
    static var appearance: UINavigationBarAppearance = {
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithTransparentBackground()
        navigationBarAppearance.backgroundColor = backgroundColor
        return navigationBarAppearance
    }()
    
    static func backButton(target: Any?, action: Selector?) -> UIBarButtonItem? {
        guard let backButtonImage = UIImage(named: "backButton") else {
            return nil
        }
        let backButtonItem = UIBarButtonItem(image: backButtonImage, style: .done, target: target, action: action)
        backButtonItem.tintColor = backButtonColor
        return backButtonItem
    }
    
    static func skipButton(target: Any?, action: Selector?) -> UIBarButtonItem? {
        let skipButtonItem = UIBarButtonItem(title: "건너뛰기", style: .done, target: target, action: action)
        skipButtonItem.setTitleTextAttributes([.font: UIFont(name: "AppleSDGothicNeo-Medium", size: 18) ?? .systemFont(ofSize: 18)], for: .normal)
        skipButtonItem.tintColor = skipTextColor
        return skipButtonItem
    }
}
