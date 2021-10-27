//
//  CommonPopupCoordinator.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/05/16.
//

import UIKit
import RxSwift

class CommonPopupCoordinator: NSObject, Coordinator {
    var delegate: CoordinatorFinishDelegate?
    var presenter: UINavigationController
    var childCoordinators: [Coordinator]
    var isTwoButton: Bool = true
    var buttonType: PopupButtonType = .none

    //피드 삭제 시 필요
    var feedID: String?
    //댓글 삭제 시 필요
    var commentID: Int?
    var reloadSubject: PublishSubject<Void>?
    
    init(presenter: UINavigationController, isTwoButton: Bool, buttonType: PopupButtonType) {
        self.presenter = presenter
        self.childCoordinators = []
        self.isTwoButton = isTwoButton
        self.buttonType = buttonType
    }
    
    func start() {
        let creationPopup = CommonPopupViewController.instantiate()
        creationPopup.coordinator = self
        creationPopup.modalPresentationStyle = .overFullScreen
        creationPopup.isTwoButton = self.isTwoButton
        creationPopup.buttonType = self.buttonType
        creationPopup.feedID = self.feedID
        creationPopup.commentID = self.commentID
        creationPopup.reloadSubject = self.reloadSubject

        presenter.present(creationPopup, animated: false, completion: nil)
    }
}

extension CommonPopupCoordinator {
    func presentLogin() {
        let coordinator = LoginPopupCoordinator(presenter: presenter)
        coordinator.delegate = self
        childCoordinators.append(coordinator)
        coordinator.start()
    }
}

