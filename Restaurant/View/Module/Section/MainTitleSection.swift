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
    weak var coordinator: HomeCoordinator?
    
    @IBOutlet weak var myContainerButton: UIButton!
    @IBOutlet weak var containerOfEveryoneButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        myContainerButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.coordinator?.presentCreationPopup()
            })
            .disposed(by: disposeBag)
        
        containerOfEveryoneButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.coordinator?.pushToContainerOfEveryone()
            })
            .disposed(by: disposeBag)
    }
    
    func configure(coordinator: HomeCoordinator) {
        self.coordinator = coordinator
    }
    
    deinit {
        print("MainTitleSection deinit")
    }
}
