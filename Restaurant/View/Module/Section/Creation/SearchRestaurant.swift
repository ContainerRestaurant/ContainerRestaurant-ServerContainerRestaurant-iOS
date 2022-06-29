//
//  SearchRestaurant.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/05/30.
//

import UIKit
import RxSwift

class SearchRestaurant: UICollectionViewCell {
    var disposeBag = DisposeBag()
    weak var coordinator: CreationFeedCoordinator?
    var restaurantSubject: PublishSubject<LocalSearchItem> = PublishSubject<LocalSearchItem>()

    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var searchRestaurantButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!

    override func prepareForReuse() {
        super.prepareForReuse()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)

        bindingView()
    }

    private func bindingView() {
        restaurantSubject
            .map { $0.title.deleteBrTag() }
            .bind(to: restaurantNameLabel.rx.text)
            .disposed(by: disposeBag)

        searchRestaurantButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { (owner, _) in
                owner.coordinator?.presentBottomSheet(owner.restaurantSubject)
            })
            .disposed(by: disposeBag)

        clearButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { (owner, _) in
                owner.restaurantNameLabel.text = ""
                owner.restaurantSubject.onNext(LocalSearchItem())
            })
            .disposed(by: disposeBag)
    }

    func configure(_ coordinator: CreationFeedCoordinator, _ subject: PublishSubject<LocalSearchItem>) {
        self.coordinator = coordinator
        self.restaurantSubject = subject
    }
}
