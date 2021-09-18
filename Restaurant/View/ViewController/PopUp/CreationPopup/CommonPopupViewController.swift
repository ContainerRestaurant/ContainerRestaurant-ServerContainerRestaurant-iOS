//
//  CommonPopupViewController.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/04/28.
//

import UIKit
import RxSwift

enum PopupButtonType {
    case creationFeed
    case none
}

class CommonPopupViewController: BaseViewController, Storyboard {
    weak var coordinator: CreationPopupCoordinator?
    var isTwoButton: Bool = true
    var buttonType: PopupButtonType = .none
    
    @IBOutlet weak var backgroundButton: UIButton!
    @IBOutlet weak var popupTitleLabel: UILabel!
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var cancelView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var okButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        cancelView.isHidden = !isTwoButton
        switch buttonType {
        case .creationFeed:
            setButton(buttonType)
            creationFeedBindingView()
        case .none: break
        }

        backgroundButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.dismiss(animated: false, completion: nil)
            })
            .disposed(by: disposeBag)
    }

    func creationFeedBindingView() {
        cancelButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.dismiss(animated: false, completion: nil)
            })
            .disposed(by: disposeBag)

        okButton.rx.tap
            .subscribe(onNext: { [weak self] in
                APIClient.checkLogin(loginToken: UserDataManager.sharedInstance.loginToken) { [weak self] userModel in
                    if userModel.id == 0 {
                        self?.dismiss(animated: false, completion: nil)
                        self?.coordinator?.presentLogin()
                    } else {
                        self?.dismiss(animated: false, completion: nil)
                        self?.coordinator?.presenter.tabBarController?.selectedIndex = 2
                    }
                }
            })
            .disposed(by: disposeBag)
    }

    private func setButton(_ buttonType: PopupButtonType) {
        switch buttonType {
        case .creationFeed:
            popupTitleLabel.text = "용기낸 경험을 들려주시겠어요?"
            cancelButton.setTitle("나중에요", for: .normal)
            okButton.setTitle("네, 좋아요!", for: .normal)
        case .none: break
        }
    }

    deinit {
        print("CreationPopupViewController Deinit")
    }
}
