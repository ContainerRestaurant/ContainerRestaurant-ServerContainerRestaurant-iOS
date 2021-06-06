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
}
