//
//  ExtensionString.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/06/03.
//

import UIKit

extension String {
    func deleteBrTag() -> String {
        return self.replacingOccurrences(of: "<b>", with: "").replacingOccurrences(of: "</b>", with: "")
    }

    func htmlToAttributedString() -> NSAttributedString? {
        guard let text = self.data(using: .utf8) else {
            return NSAttributedString()
        }

        do {
            return try NSAttributedString(data: text, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
}

extension NSMutableAttributedString {
    func bold(string: String, fontColor: UIColor, fontSize: CGFloat) -> NSMutableAttributedString {
        let font = UIFont.boldSystemFont(ofSize: fontSize)
        let attributes: [NSAttributedString.Key: Any] = [.font: font, .foregroundColor: fontColor]
        self.append(NSAttributedString(string: string, attributes: attributes))
        return self
    }

    func regular(string: String, fontColor: UIColor, fontSize: CGFloat) -> NSMutableAttributedString {
        let font = UIFont.systemFont(ofSize: fontSize)
        let attributes: [NSAttributedString.Key: Any] = [.font: font, .foregroundColor: fontColor]
        self.append(NSAttributedString(string: string, attributes: attributes))
        return self
    }
}
