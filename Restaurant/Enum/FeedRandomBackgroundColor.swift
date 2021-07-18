//
//  FeedRandomBackgroundColor.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/07/18.
//

import UIKit

enum FeedBackgroundColor: CaseIterable {
    case blue
    case green
    case yellow
    
    func color() -> UIColor {
        switch self {
        case .blue: return .colorPointBlue01
        case .green: return .colorMainGreen02
        case .yellow: return .colorSubYellow02
        }
    }
}
