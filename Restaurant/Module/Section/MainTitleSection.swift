//
//  MainTitleSection.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/04/26.
//

import UIKit
import RxSwift
import RxCocoa

class MainTitleSection: UICollectionViewCell {
    let disposeBag = DisposeBag()
    var viewController: BaseViewController?
    
    @IBOutlet weak var myContainerButton: UIButton!
    @IBOutlet weak var containerOfEveryoneButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        myContainerButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                let testPopupVC = popUpViewController()
                testPopupVC.modalPresentationStyle = .overFullScreen
                self?.viewController?.present(testPopupVC, animated: false, completion: nil)
            })
            .disposed(by: disposeBag)
        
        containerOfEveryoneButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.setNextVCNavigationItem()
                let containerOfEveryoneVC = ContainerOfEveryoneViewController()
                self?.viewController?.push(viewController: containerOfEveryoneVC)
            })
            .disposed(by: disposeBag)
    }
    
    func setNextVCNavigationItem() {
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self.viewController, action: nil)
        backBarButtonItem.tintColor = .colorGreyGrey01
        self.viewController?.navigationItem.backBarButtonItem = backBarButtonItem
        
        let backImage = UIImage(named: "chevronLeftOutline20Px")
        self.viewController?.navigationController?.navigationBar.backIndicatorImage = backImage
        self.viewController?.navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImage
    }
    
    func configure(viewController: BaseViewController) {
        self.viewController = viewController
    }
    
    deinit {
        print("MainTitleSection deinit")
    }
}
