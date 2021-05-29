//
//  ExtensionCGFloat.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/05/29.
//

import UIKit

extension CGFloat {
    func ratio() -> CGFloat {
        return UIScreen.main.bounds.width / CGFloat(375) * self
    }
}
