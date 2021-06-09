//
//  ExtensionUIButton.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/06/07.
//

import UIKit

extension UIButton {
    func underLineTitle(_ text: String, _ color: UIColor, _ font: UIFont) {
        let yourAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font: font,
            NSAttributedString.Key.foregroundColor: color,
            NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue
        ]

        let attributeString = NSMutableAttributedString(
            string: text,
            attributes: yourAttributes
        )
        self.setAttributedTitle(attributeString, for: .normal)
    }
}
