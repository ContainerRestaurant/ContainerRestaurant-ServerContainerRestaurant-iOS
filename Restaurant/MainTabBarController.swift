//
//  MainTabBarController.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/04/20.
//

import UIKit

class MainTabBarController: UITabBarController {
    @IBOutlet var test: UITabBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for (index, item) in TabBarItem.allCases.enumerated() {
            test.items?[index].image = item.iconImage
            test.items?[index].selectedImage = item.selectedIconImage
            test.items?[index].title = item.text
        }
    }
}
