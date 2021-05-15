//
//  TabBarItem.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/04/20.
//

import Foundation
import UIKit

enum TabBarItem: CaseIterable {
    case home
    case search
    case creation
    case map
    case my
    
    var viewController: UIViewController {
        switch self {
        case .home: return HomeViewController()
        case .search: return SearchViewController()
        case .creation: return CreationViewController()
        case .map: return MapViewController()
        case .my: return MyViewController()
        }
    }
    
    var title: String {
        switch self {
        case .home: return "홈"
        case .search: return "탐색"
        case .creation: return ""
        case .map: return "지도"
        case .my: return "마이"
        }
    }
    
    var iconImage: UIImage? {
        switch self {
        case .home: return UIImage(named: "iconHomeOutline20Px")
        case .search: return UIImage(named: "iconFeedOutline20Px")
        case .creation: return UIImage(named: "iconAddFilled40Px")
        case .map: return UIImage(named: "iconMapOutline20Px")
        case .my: return UIImage(named: "iconMypageOutline20Px")
        }
    }
    
    var selectedIconImage: UIImage? {
        switch self {
        case .home: return UIImage(named: "iconHomeFilled20Px")
        case .search: return UIImage(named: "iconFeedFilled20Px")
        case .creation: return UIImage(named: "iconAddFilled40Px")
        case .map: return UIImage(named: "iconMapFilled20Px")
        case .my: return UIImage(named: "iconMypageFilled20Px")
        }
    }
}
