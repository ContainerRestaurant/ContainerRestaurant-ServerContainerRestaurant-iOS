//
//  RecentlyFeedCreationUserCollectionViewCell.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/05/09.
//

import UIKit

class RecentlyFeedCreationUserCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configure(user: UserModel) {
        if user.profile.isEmpty {
            imageView.image = Common.getDefaultProfileImage74(user.levelTitle)
        } else {
            imageView.kf.setImage(with: URL(string: user.profile), options: [.transition(.fade(0.3))])
        }
        nicknameLabel.text = user.nickname
        levelLabel.text = user.levelTitle
    }
}
