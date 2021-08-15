//
//  RestaurantInformationOnFeedDetail.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/08/15.
//

import UIKit
import RxSwift
import RxCocoa

class RestaurantInformationOnFeedDetail: UICollectionViewCell {
    let disposeBag = DisposeBag()

    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var categoryButton: UIButton!
    @IBOutlet weak var restaurantNameButton: UIButton!
    @IBOutlet weak var isWelcomeView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()

        //물어보기
        self.borderView.applySketchShadow(color: .colorGrayGray08, alpha: 0.15, x: 0, y: 0, blur: 5, spread: 0)
    }

    func configure(category: Driver<String>, restaurantName: Driver<String>, isWelcome: Driver<Bool>) {
        category
            .drive(categoryButton.rx.title(for: .normal))
            .disposed(by: disposeBag)

        restaurantName
            .drive(restaurantNameButton.rx.title(for: .normal))
            .disposed(by: disposeBag)

        isWelcome
            .map { !$0 }
            .drive(isWelcomeView.rx.isHidden)
            .disposed(by: disposeBag)
    }
}
