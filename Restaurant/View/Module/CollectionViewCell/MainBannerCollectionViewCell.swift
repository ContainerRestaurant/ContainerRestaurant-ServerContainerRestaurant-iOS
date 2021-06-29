//
//  MainBannerCollectionViewCell.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/06/18.
//

import UIKit

class MainBannerCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(imageURL: String) {
        let totalURL = baseURL + imageURL
        let URL = URL(string: totalURL)
        imageView.kf.setImage(with: URL, options: [.transition(.fade(0.3))])
    }
}
