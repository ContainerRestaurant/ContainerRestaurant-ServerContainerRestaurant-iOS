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
    
    func configure(_ recommendFeed: FeedPreviewModel) {
//        let imageURL = URL(string: Router.baseURLString + recommendFeed.thumbnailUrl)
        let imageURL = URL(string: recommendFeed.thumbnailUrl)
//        let imageURL = URL(string: "http://ec2-52-78-66-184.ap-northeast-2.compute.amazonaws.com/api/image/03b8ccde-9b83-5904-8029-a4dc1b559326.jpeg")
        
        
        feedImageView.kf.setImage(with: imageURL, options: [.transition(.fade(0.3))])
        nicknameLabel.text = recommendFeed.ownerNickname
        contentLabel.text = recommendFeed.content
        likeCountLabel.text = String(recommendFeed.likeCount)
        replyCountLabel.text = String(recommendFeed.replyCount)
    }
}
