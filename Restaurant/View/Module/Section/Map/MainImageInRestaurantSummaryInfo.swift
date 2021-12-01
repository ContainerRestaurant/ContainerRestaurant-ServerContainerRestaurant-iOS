//
//  MainImageInRestaurantSummaryInfo.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/07/31.
//

import UIKit

class MainImageInRestaurantSummaryInfo: UICollectionViewCell {
    @IBOutlet weak var mainImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configure(imageURL: String) {
        if !imageURL.isEmpty {
            mainImageView.kf.setImage(with: URL(string: imageURL), options: [.transition(.fade(0.3))])
        }
    }
}
