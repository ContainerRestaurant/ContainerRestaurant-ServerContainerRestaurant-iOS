//
//  TwoFeedCollectionViewCell.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/04/27.
//

import UIKit
import RxSwift

class TwoFeedCollectionViewCell: UICollectionViewCell {
    var disposeBag = DisposeBag()
    var coordinator: Any?

    @IBOutlet weak var feedImageView: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var replyCountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        disposeBag = DisposeBag()
    }
    
    func configure(_ feedPreview: FeedPreviewModel, _ coordinator: Any) {
        self.coordinator = coordinator

        if feedPreview.thumbnailUrl.isEmpty {
            feedImageView.image = UIImage(named: "emptyFeedImgIos")
            feedImageView.backgroundColor = FeedBackgroundColor.allCases.randomElement()?.color()
        } else {
            let imageURL = URL(string: feedPreview.thumbnailUrl)
            feedImageView.kf.setImage(with: imageURL, options: [.transition(.fade(0.3))])
        }
        nicknameLabel.text = feedPreview.userNickname
        contentLabel.lineSpacing(text: feedPreview.content, lineSpacing: 3, numberOfLines: 2)
        likeCountLabel.text = String(feedPreview.likeCount)
        replyCountLabel.text = String(feedPreview.commentCount)
        likeButton.setImage(UIImage(named: feedPreview.isLike ? "likeFilled20Px" : "likeOutlineWhite20Px"), for: .normal)

        likeButton
            .rx.tap
            .bind { [weak self] in self?.likeAction(feedPreview.id) }
            .disposed(by: disposeBag)
    }

    private func likeAction(_ feedID: Int) {
        APIClient.checkLogin(loginToken: UserDataManager.sharedInstance.loginToken) { [weak self] userModel in
            if userModel.id == 0 {
                switch self?.coordinator {
                case is HomeCoordinator:
                    (self?.coordinator as? HomeCoordinator)?.presentLogin()
                case is FeedCoordinator:
                    (self?.coordinator as? FeedCoordinator)?.presentLogin()
                case is InquiryProfileCoordinator:
                    (self?.coordinator as? InquiryProfileCoordinator)?.presentLogin()
                case is RestaurantSummaryInformationCoordinator:
                    (self?.coordinator as? RestaurantSummaryInformationCoordinator)?.presentLogin()
                default: break
                }
            } else {
                guard let `self` = self else { return }

                let isLiked = self.likeButton.image(for: .normal) == UIImage(named: "likeFilled20Px")
                APIClient.likeFeed(feedID: feedID, cancel: isLiked)
                self.likeButton.setImage(UIImage(named: isLiked ? "likeOutlineWhite20Px" : "likeFilled20Px"), for: .normal)

                let likeCount = Int(self.likeCountLabel.text ?? "0") ?? 0
                self.likeCountLabel.text = isLiked ? String(likeCount-1) : String(likeCount+1)
                Common.hapticVibration()
            }
        }
    }
}
