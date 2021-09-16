//
//  ExtensionString.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/06/03.
//

import Foundation

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
