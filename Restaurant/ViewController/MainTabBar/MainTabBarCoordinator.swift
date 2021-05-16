//
//  MainTabBarCoordinator.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/05/15.
//

import UIKit

class MainTabBarCoordinator: NSObject, Coordinator {
    enum TabBarItem: CaseIterable {
        case home
        case search
        case creation
        case map
        case my
        
        var title: String {
            switch self {
            case .home: return "홈"
            case .search: return "검색"
            case .creation: return ""
            case .map: return "지도"
            case .my: return "마이"
            }
        }
        var image: UIImage {
            switch self {
            case .home: return (UIImage(named: "homeOutline20Px")?.withRenderingMode(.alwaysOriginal))!
            case .search: return (UIImage(named: "feedOutline20Px")?.withRenderingMode(.alwaysOriginal))!
            case .creation: return (UIImage(named: "addFilled40Px")?.withRenderingMode(.alwaysOriginal))!
            case .map: return (UIImage(named: "mapOutline20Px")?.withRenderingMode(.alwaysOriginal))!
            case .my: return (UIImage(named: "mypageOutline20Px")?.withRenderingMode(.alwaysOriginal))!
            }
        }
        var selectedImage: UIImage {
            switch self {
            case .home: return (UIImage(named: "homeFilled20Px")?.withRenderingMode(.alwaysOriginal))!
            case .search: return (UIImage(named: "feedFilled20Px")?.withRenderingMode(.alwaysOriginal))!
            case .creation: return (UIImage(named: "addFilled40Px")?.withRenderingMode(.alwaysOriginal))!
            case .map: return (UIImage(named: "mapFilled20Px")?.withRenderingMode(.alwaysOriginal))!
            case .my: return (UIImage(named: "mypageFilled20Px")?.withRenderingMode(.alwaysOriginal))!
            }
        }
        
        func getCoordinator(presenter: UINavigationController) -> Coordinator {
            switch self {
            case .home: return HomeCoordinator(presenter: presenter)
            case .search: return SearchCoordinator(presenter: presenter)
            case .creation: return CreationCoordinator(presenter: presenter)
            case .map: return MapCoordinator(presenter: presenter)
            case .my: return MyCoordinator(presenter: presenter)
            }
        }
    }
    
    var delegate: CoordinatorFinishDelegate?
    var presenter: UINavigationController
    var childCoordinators: [Coordinator]
    var tabBarController: UITabBarController
    var tabBarItems: [TabBarItem] = [.home, .search, .creation, .map, .my]
    
    init(presenter: UINavigationController) {
        self.presenter = presenter
        self.childCoordinators = []
        self.tabBarController = UITabBarController()
    }
    
    func start() {
        let controllers = tabBarItems.map { getTabController(item: $0) }
        prepareTabBarController(withTabControllers: controllers)
    }
    
    func getTabController(item: TabBarItem) -> UINavigationController {
        let navigationController = UINavigationController()
        let tabItem = UITabBarItem(title: item.title, image: item.image, selectedImage: item.selectedImage)
        navigationController.tabBarItem = tabItem
        
        let coordinator = item.getCoordinator(presenter: navigationController)
        coordinator.delegate = self
        childCoordinators.append(coordinator)
        coordinator.start()
        
        return navigationController
    }

    private func prepareTabBarController(withTabControllers tabControllers: [UIViewController]) {
        tabBarController.setViewControllers(tabControllers, animated: true)
        tabBarController.selectedIndex = 0
        tabBarController.tabBar.isTranslucent = false
        tabBarController.tabBar.tintColor = .colorGrayGray07
        
        presenter.viewControllers = [tabBarController]
    }
}
