//
//  FeedInRestaurantSummaryInfo.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/07/31.
//

import UIKit

class FeedInRestaurantSummaryInfo: UICollectionViewCell {
    var restaurantFeed: [FeedPreviewModel] = []
    var coordinator: RestaurantSummaryInformationCoordinator?

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var feedCountDescriptionLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        setCollectionView()
    }

    func configure(restaurantFeed: [FeedPreviewModel], coordinator: RestaurantSummaryInformationCoordinator) {
        self.restaurantFeed = restaurantFeed
        self.coordinator = coordinator

        feedCountDescriptionLabel.text = "총 \(restaurantFeed.count)개의 용기낸 피드가 있어요"
    }
}

extension FeedInRestaurantSummaryInfo {
    private func setCollectionView() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self

        self.collectionView.register(TwoFeedCollectionViewCell.self)
    }
}

extension FeedInRestaurantSummaryInfo: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return restaurantFeed.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: TwoFeedCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        if let coordinator = coordinator {
            cell.configure(restaurantFeed[indexPath.row], coordinator)
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: CGFloat(164).widthRatio(), height: 272)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(15)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(20)
    }
}
