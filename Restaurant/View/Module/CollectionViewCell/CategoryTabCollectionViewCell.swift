//
//  CategoryTabCollectionViewCell.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/07/07.
//

import UIKit

class CategoryTabCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var categoryButton: UIButton!
    @IBOutlet weak var categoryLabel: PaddingLabel!
    @IBOutlet weak var underLineView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(_ title: String, _ isSelected: Bool) {
        categoryLabel.text = title
        categoryLabel.font = isSelected ? .boldSystemFont(ofSize: 16) : .systemFont(ofSize: 16)
        categoryLabel.textColor = isSelected ? .colorGrayGray07 : .colorGrayGray06
        underLineView.isHidden = !isSelected
    }
}
