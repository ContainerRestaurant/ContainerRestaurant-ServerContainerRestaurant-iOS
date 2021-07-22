//
//  Common.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/06/01.
//

import UIKit

struct Common {
    static var homeBarHeight: CGFloat = 35
    static var tabBarHeight: CGFloat = 48
    static var notchHeight: CGFloat = 48
    static var isNotchPhone: Bool {
        return UIScreen.main.bounds.height > CGFloat(700)
    }

    //topViewController에서 currentViewController로 수정
    static func currentViewController() -> UIViewController? {
        var viewController = UIApplication.shared.windows.first!.rootViewController

        while viewController?.presentedViewController != nil {
            viewController = viewController?.presentedViewController!
        }
        print("currentViewController -> \(String(describing: viewController))")

        return viewController
    }
}
