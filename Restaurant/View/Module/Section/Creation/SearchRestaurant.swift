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
    var restaurantSubject: PublishSubject<LocalSearchItem> = PublishSubject<LocalSearchItem>()

    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var searchRestaurantButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()

        searchRestaurantButton.rx.tap
            .subscribe(onNext: { [weak self] in
                if let subject = self?.restaurantSubject {
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

    func configure(_ coordinator: CreationFeedCoordinator, _ subject: PublishSubject<LocalSearchItem>) {
        self.coordinator = coordinator
        restaurantSubject = subject

        restaurantSubject
            .map { $0.title.deleteBrTag() }
            .bind(to: restaurantNameLabel.rx.text)
            .disposed(by: disposeBag)
    }
}

//MARK: - Instance Method
extension SearchRestaurant {

}
