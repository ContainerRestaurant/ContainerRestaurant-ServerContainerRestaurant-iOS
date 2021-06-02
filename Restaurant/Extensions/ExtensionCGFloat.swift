//
//  ExtensionCGFloat.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/05/29.
//

import UIKit

extension CGFloat {
    func widthRatio() -> CGFloat {
        return UIScreen.main.bounds.width / CGFloat(375) * self
    }

    func heightRatio() -> CGFloat {
        return UIScreen.main.bounds.height / CGFloat(812) * self
    }
}
