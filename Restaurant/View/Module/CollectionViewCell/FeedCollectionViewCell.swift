//
//  FeedCollectionViewCell.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/04/27.
//

import UIKit

class FeedCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var feedImageView: UIImageView!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var replyCountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(_ recommendFeed: FeedPreviewModel) {
        let imageURL = URL(string: Router.baseURLString + recommendFeed.thumbnailUrl)
        
        feedImageView.kf.setImage(with: imageURL, options: [.transition(.fade(0.3))])
        nicknameLabel.text = recommendFeed.ownerNickname
        contentLabel.text = recommendFeed.content
        likeCountLabel.text = String(recommendFeed.likeCount)
        replyCountLabel.text = String(recommendFeed.replyCount)
    }
}
