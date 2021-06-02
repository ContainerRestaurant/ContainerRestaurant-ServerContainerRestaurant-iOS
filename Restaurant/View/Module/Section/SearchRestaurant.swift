//
//  SearchRestaurant.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/05/30.
//

import UIKit
import RxSwift
import FittedSheets

class SearchRestaurant: UICollectionViewCell {
    let disposeBag = DisposeBag()
    weak var coordinator: CreationFeedCoordinator?
    var restaurantNameSubject: BehaviorSubject<String>?

    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var searchRestaurantButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()

        searchRestaurantButton.rx.tap
            .subscribe(onNext: { [weak self] in
                if let subject = self?.restaurantNameSubject {
                    self?.coordinator?.presentBottomSheet(subject)
                }
            })
            .disposed(by: disposeBag)

        clearButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.restaurantNameLabel.text = ""
            })
            .disposed(by: disposeBag)
    }

    func configure(_ coordinator: CreationFeedCoordinator, _ subject: BehaviorSubject<String>) {
        self.coordinator = coordinator
        restaurantNameSubject = subject

        subject
            .bind(to: restaurantNameLabel.rx.text)
            .disposed(by: disposeBag)
    }
}

//MARK: - Instance Method
extension SearchRestaurant {

}
