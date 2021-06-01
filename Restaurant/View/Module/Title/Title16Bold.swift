//
//  Title16Bold.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/04/27.
//

import UIKit

class Title16Bold: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configure(title: String) {
        self.titleLabel.text = title
    }
}
