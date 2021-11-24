//
//  ExtensionUILabel.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/09/19.
//

import UIKit

extension UILabel {
    func lineSpacing(text: String, lineSpacing: CGFloat, numberOfLines: Int = 0) {
        self.text = text
        self.numberOfLines = numberOfLines
        let attrString = NSMutableAttributedString(string: self.text ?? "")
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attrString.length))
        self.attributedText = attrString
    }
}
