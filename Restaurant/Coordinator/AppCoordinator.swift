//
//  AppCoordinator.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/05/15.
//

import UIKit

class AppCoordinator: NSObject, Coordinator {
    // MARK: Properties
    var delegate: CoordinatorFinishDelegate?
    let window: UIWindow
    var presenter: UINavigationController
    var childCoordinators: [Coordinator]
    var tabBarController: UITabBarController
    
    // MARK: Initializing
    init(window: UIWindow) {
        self.window = window
        
        let navigationController = UINavigationController()
        navigationController.setNavigationBarHidden(true, animated: true)
        self.presenter = navigationController
        
        self.childCoordinators = []
        self.tabBarController = UITabBarController()
    }
    
    func start() {
        window.rootViewController = presenter

        if UserDataManager.sharedInstance.isFirstEntry {
            UserDataManager.sharedInstance.isFirstEntry = false
            let coordinator = OnboardingCoordinator(presenter: presenter)
            coordinator.delegate = self
            childCoordinators.append(coordinator)
            coordinator.start()
        } else {
            let coordinator = MainTabBarCoordinator(presenter: presenter)
            coordinator.delegate = self
            childCoordinators.append(coordinator)
            coordinator.start()

            checkAppVersion()
        }
        
        window.makeKeyAndVisible()
    }

    private func checkAppVersion() {
        APIClient.appVersion() { [weak self] appVersionModel in
            guard let self = self else { return }
            guard let myVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else { return }

            if myVersion < appVersionModel.minimumVersion {
                let coordinator = CommonPopupCoordinator(presenter: self.presenter, isTwoButton: false, buttonType: .forceUpdate)
                coordinator.delegate = self
                self.childCoordinators.append(coordinator)
                coordinator.start()
            } else if myVersion < appVersionModel.latestVersion {
                let coordinator = CommonPopupCoordinator(presenter: self.presenter, isTwoButton: true, buttonType: .selectUpdate)
                coordinator.delegate = self
                self.childCoordinators.append(coordinator)
                coordinator.start()
            } else {
                print("최신 버전")
            }
        }
    }
}
