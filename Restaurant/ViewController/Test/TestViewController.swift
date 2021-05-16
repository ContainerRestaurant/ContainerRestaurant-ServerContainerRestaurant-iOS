//
//  TestViewController.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/04/13.
//

import UIKit
import FittedSheets

class TestViewController: BaseViewController {
    @IBOutlet weak var mapTestButton: UIButton!
    @IBOutlet weak var loginTestButton: UIButton!
    @IBOutlet weak var popUpTestButton: UIButton!
    @IBOutlet weak var sheetTestButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapTestButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.push(viewController: TestMapViewController())
            })
            .disposed(by: disposeBag)
        
        loginTestButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                if #available(iOS 13.0, *) {
                    self?.push(viewController: TestLoginViewController())
                } else {
                    print("lower version")
                }
            })
            .disposed(by: disposeBag)

        popUpTestButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                let popupVC = CreationPopupViewController()
                popupVC.modalPresentationStyle = .overFullScreen
                self?.present(popupVC, animated: false, completion: nil)
            })
            .disposed(by: disposeBag)
        
        sheetTestButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                let testViewController = TestLoginViewController()
                let sheetViewController = SheetViewController(controller: testViewController,
                                                              sizes: [.fixed(150), .marginFromTop(200)],
                                                              options: SheetOptions(
                                                                useFullScreenMode: true,
                                                                shrinkPresentingViewController: false))
                sheetViewController.dismissOnPull = true
                sheetViewController.didDismiss = { _ in
                    print("sheetViewController didDismiss")
                }
                if sheetViewController.shouldRecognizePanGestureWithUIControls {
                    print("pan 시작")
                }
                
                self?.present(sheetViewController, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
    }

    deinit {
        print("TestViewController Deinit")
    }
}
