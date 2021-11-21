//
//  LevelUpPopupCoordinator.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/11/21.
//

import UIKit

class LevelUpPopupCoordinator: NSObject, Coordinator {
    var delegate: CoordinatorFinishDelegate?
    var presenter: UINavigationController
    var childCoordinators: [Coordinator]

    init(presenter: UINavigationController) {
        self.presenter = presenter
        self.childCoordinators = []
    }

    func start(levelUp: LevelUpModel, okAction: @escaping () -> Void) {
        let levelUpPopup = LevelUpPopupViewController.instantiate()
        levelUpPopup.coordinator = self
        levelUpPopup.modalPresentationStyle = .fullScreen
        levelUpPopup.levelUp = levelUp
        levelUpPopup.okAction = okAction

        Common.currentViewController()?.present(levelUpPopup, animated: false, completion: nil)
//        presenter.present(levelUpPopup, animated: true, completion: nil)
    }
}
