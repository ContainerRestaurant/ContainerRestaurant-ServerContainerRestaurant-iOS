//
//  MostFeedTopTenCollectionViewCell.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/05/09.
//

import UIKit

class MostFeedTopTenCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(nickName: String, level: String) {
        nickNameLabel.text = nickName
        levelLabel.text = level
    }
}
