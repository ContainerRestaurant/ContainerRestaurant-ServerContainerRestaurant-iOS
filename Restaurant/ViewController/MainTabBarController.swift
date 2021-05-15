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
  
        setTabBar()
    }
    
    func setTabBar() {
        guard let view01 =  self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") else { return }
        guard let view02 =  self.storyboard?.instantiateViewController(withIdentifier: "SearchViewController") as? SearchViewController else { return }
//        view02.bind()
        guard let view03 =  self.storyboard?.instantiateViewController(withIdentifier: "CreationViewController") else { return }
        guard let view04 =  self.storyboard?.instantiateViewController(withIdentifier: "MapViewController") else { return }
        guard let view05 =  self.storyboard?.instantiateViewController(withIdentifier: "MyViewController") else { return }
        
        view01.tabBarItem = UITabBarItem(title: "홈", image: UIImage(named: "iconHomeOutline20Px"), selectedImage: UIImage(named: "iconHomeFilled20Px"))
        view02.tabBarItem = UITabBarItem(title: "탐색", image: UIImage(named: "iconFeedOutline20Px"), selectedImage: UIImage(named: "iconFeedFilled20Px"))
        view03.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "iconAddFilled40Px"), selectedImage: UIImage(named: "iconAddFilled40Px"))
        view04.tabBarItem = UITabBarItem(title: "지도", image: UIImage(named: "iconMapOutline20Px"), selectedImage: UIImage(named: "iconMapFilled20Px"))
        view05.tabBarItem = UITabBarItem(title: "마이", image: UIImage(named: "iconMypageOutline20Px"), selectedImage: UIImage(named: "iconMypageFilled20Px"))
        
//        let VCs = [UINavigationController(rootViewController: view01),
//                   view02, view03, view04, view05]
        let viewControllers = [UINavigationController(rootViewController: view01),
                               UINavigationController(rootViewController: view02),
                               UINavigationController(rootViewController: view03),
                               UINavigationController(rootViewController: view04),
                               UINavigationController(rootViewController: view05)]
        self.setViewControllers(viewControllers, animated: false)
    }
}
