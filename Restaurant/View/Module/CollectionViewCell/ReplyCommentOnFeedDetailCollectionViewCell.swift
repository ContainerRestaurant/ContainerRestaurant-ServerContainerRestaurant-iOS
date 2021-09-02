//
//  ReplyCommentOnFeedDetailCollectionViewCell.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/09/01.
//

import UIKit

class ReplyCommentOnFeedDetailCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var userProfileImageView: UIImageView!
    @IBOutlet weak var userNicknameLabel: UILabel!
    @IBOutlet weak var userLevelTitleLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var createdDateLabel: UILabel!
    @IBOutlet weak var likeCountButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configure(comment: CommentModel) {
        userProfileImageView.image = Common.getDefaultProfileImage32(comment.userLevelTitle)
        userNicknameLabel.text = comment.userNickname
        userLevelTitleLabel.text = comment.userLevelTitle
        commentLabel.text = comment.content == "" ? "내용이 입력되지 않은 댓글입니다." : comment.content
        createdDateLabel.text = comment.createdDate
        likeCountButton.setTitle("\(comment.likeCount)", for: .normal)
    }
}
