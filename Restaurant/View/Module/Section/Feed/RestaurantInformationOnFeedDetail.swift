//
//  RestaurantInformationOnFeedDetail.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/08/15.
//

import UIKit
import RxSwift
import RxCocoa

struct RestaurantLocation {
    static var sharedInstance = RestaurantLocation()

    var isEntryRestaurantInformation: Bool = false
    var latitude: Double = 0.0
    var longtitude: Double = 0.0
}

class RestaurantInformationOnFeedDetail: UICollectionViewCell {
    let disposeBag = DisposeBag()
    var latitude: Double?
    var longitude: Double?

    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var categoryButton: UIButton!
    @IBOutlet weak var restaurantNameButton: UIButton!
    @IBOutlet weak var isWelcomeView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()

        self.borderView.applySketchShadow(color: .colorGrayGray08, alpha: 0.15, x: 0, y: 0, blur: 5, spread: 0)
        categoryButton.cornerRadius = categoryButton.frame.width/1.7
    }

    func configure(_ viewModel: FeedDetailViewModel, _ coordinator : FeedDetailCoordinator?) {
        latitude = viewModel.latitude
        longitude = viewModel.longitude

        viewModel.categoryDriver
            .drive(categoryButton.rx.title(for: .normal))
            .disposed(by: disposeBag)

        viewModel.restaurantNameDriver
            .drive(restaurantNameButton.rx.title(for: .normal))
            .disposed(by: disposeBag)

        viewModel.isWelcomeDriver
            .map { !$0 }
            .drive(isWelcomeView.rx.isHidden)
            .disposed(by: disposeBag)

        restaurantNameButton.rx.tap
            .bind(onNext: { [weak self] in self?.clickedRestaurant(coordinator: coordinator) })
            .disposed(by: disposeBag)
    }

    func clickedRestaurant(coordinator: FeedDetailCoordinator?) {
        RestaurantLocation.sharedInstance.isEntryRestaurantInformation = true
        RestaurantLocation.sharedInstance.latitude = latitude!
        RestaurantLocation.sharedInstance.longtitude = longitude!
        if coordinator?.presenter.tabBarController?.selectedIndex == 3 {
            coordinator?.presenter.popViewController(animated: true)
        } else {
            coordinator?.presenter.tabBarController?.selectedIndex = 3
        }
    }
}
