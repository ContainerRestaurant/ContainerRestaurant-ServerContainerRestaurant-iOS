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
        let URL = URL(string: imageURL)
        imageView.kf.setImage(with: URL, options: [.transition(.fade(0.3))])
    }
}
