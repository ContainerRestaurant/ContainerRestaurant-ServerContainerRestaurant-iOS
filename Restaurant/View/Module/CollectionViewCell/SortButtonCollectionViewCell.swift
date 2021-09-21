//
//  SortButtonCollectionViewCell.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/09/19.
//

import UIKit

class SortButtonCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var sortLabel: PaddingLabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configure(_ isSelected: Bool, _ title: String) {
        sortLabel.borderColor = isSelected ? .colorMainGreen02 : .colorGrayGray03
        sortLabel.textColor = isSelected ? .colorMainGreen02 : .colorGrayGray05
        sortLabel.font = isSelected ? .boldSystemFont(ofSize: 14) : .systemFont(ofSize: 14)
        sortLabel.text = title
    }
}
