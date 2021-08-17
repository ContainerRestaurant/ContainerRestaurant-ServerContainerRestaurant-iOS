//
//  TwoFeedCollectionViewCell.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/04/27.
//

import UIKit

class TwoFeedCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var feedImageView: UIImageView!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var replyCountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
//    override func prepareForReuse() {
//        feedImageView.image = nil
//        nicknameLabel.text = ""
//        contentLabel.text = ""
//        likeCountLabel.text = "0"
//        replyCountLabel.text = "0"
//    }
    
    func configure(_ feedPreview: FeedPreviewModel) {
        if feedPreview.thumbnailUrl.isEmpty {
            feedImageView.image = UIImage(named: "emptyFeedImgIos")
            feedImageView.backgroundColor = FeedBackgroundColor.allCases.randomElement()?.color()
        } else {
            let imageURL = URL(string: feedPreview.thumbnailUrl)
            feedImageView.kf.setImage(with: imageURL, options: [.transition(.fade(0.3))])
        }
        nicknameLabel.text = feedPreview.ownerNickname
        contentLabel.text = feedPreview.content
        likeCountLabel.text = String(feedPreview.likeCount)
        replyCountLabel.text = String(feedPreview.replyCount)
    }
}
