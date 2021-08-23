//
//  MostFeedCreationUserCollectionViewCell.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/05/09.
//

import UIKit

class MostFeedCreationUserCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(user: UserModel) {
        if user.profile.isEmpty {
            imageView.image = Common.getDefaultProfileImage148(user.levelTitle)
        } else {
            imageView.kf.setImage(with: URL(string: user.profile), options: [.transition(.fade(0.3))])
        }
        nickNameLabel.text = user.nickname
        levelLabel.text = user.levelTitle
    }
}
