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

//    static func showToast(controller: UIViewController, message: String, seconds: Double) {
//        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
//        alert.view.backgroundColor = .black
//        alert.view.alpha = 0.6
//        alert.view.layer.cornerRadius = 15
//
//        controller.present(alert, animated: true)
//
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
//            alert.dismiss(animated: true)
//        }
//    }

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
