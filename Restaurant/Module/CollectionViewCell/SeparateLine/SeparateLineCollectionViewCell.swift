//
//  SeparateLineCollectionViewCell.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/05/01.
//

import UIKit

class SeparateLineCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var lineViewHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureCell(height: CGFloat = 1, color: UIColor = .gray) {
        lineViewHeight.constant = height
        lineView.backgroundColor = color
    }
}
