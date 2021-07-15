//
//  ViewMoreButton.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/07/16.
//

import UIKit
import RxSwift

class ViewMoreButton: UICollectionViewCell {
    var disposeBag = DisposeBag()
    weak var coordinator: HomeCoordinator?
    
    @IBOutlet weak var viewMoreButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        viewMoreButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.coordinator?.presenter.tabBarController?.selectedIndex = 1
            })
            .disposed(by: disposeBag)
    }
    
    func configure(_ coordinator: HomeCoordinator) {
        self.coordinator = coordinator
    }
}
