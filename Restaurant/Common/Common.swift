//
//  Common.swift
//  Restaurant
//
//  Created by Lotte on 2021/06/01.
//

import UIKit

struct Common {
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
