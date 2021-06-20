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

    func configure(testIndex: Int) {
        switch testIndex {
        case 0: imageView.backgroundColor = .red
        case 1: imageView.backgroundColor = .orange
        case 2: imageView.backgroundColor = .yellow
        default: imageView.backgroundColor = .green
        }
    }
}
