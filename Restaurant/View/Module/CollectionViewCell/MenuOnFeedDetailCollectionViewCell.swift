//
//  MenuOnFeedDetailCollectionViewCell.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/08/16.
//

import UIKit

class MenuOnFeedDetailCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var menuNameLabel: UILabel!
    @IBOutlet weak var containerNameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configure(menuAndContainer: MenuAndContainerModel) {
        menuNameLabel.text = menuAndContainer.menuName
        containerNameLabel.text = menuAndContainer.container
    }
}
