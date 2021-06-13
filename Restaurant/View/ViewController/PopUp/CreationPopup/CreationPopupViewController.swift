//
//  CreationPopupViewController.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/04/28.
//

import UIKit
import RxSwift

class CreationPopupViewController: BaseViewController, Storyboard {
    weak var coordinator: CreationPopupCoordinator?
    
    @IBOutlet weak var backgroundButton: UIButton!
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var okButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        backgroundButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.dismiss(animated: false, completion: nil)
            })
            .disposed(by: disposeBag)
        
        cancelButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.dismiss(animated: false, completion: nil)
            })
            .disposed(by: disposeBag)

        okButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.dismiss(animated: false, completion: nil)
                self?.coordinator?.presentLogin()
            })
            .disposed(by: disposeBag)
    }

    deinit {
        print("CreationPopupViewController Deinit")
    }
}
