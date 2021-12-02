//
//  ReplyCommentOnFeedDetailCollectionViewCell.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/09/01.
//

import UIKit
import RxSwift

class ReplyCommentOnFeedDetailCollectionViewCell: UICollectionViewCell {
    var disposeBag = DisposeBag()
    var comment: CommentModel?
    var coordinator: FeedDetailCoordinator?
    var reloadSubject: PublishSubject<Void>?
    var updateCommentSubject: PublishSubject<CommentModel>?

    @IBOutlet weak var userProfileImageView: UIImageView!
    @IBOutlet weak var userNicknameLabel: UILabel!
    @IBOutlet weak var userLevelTitleLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var createdDateLabel: UILabel!
    @IBOutlet weak var likeCountButton: UIButton!
    @IBOutlet weak var moreButton: UIButton!
    @IBAction func clickedUserProfileImage(_ sender: Any) {
        if let userID = comment?.userID {
            coordinator?.pushToInquiryProfile(userID: userID)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configure(comment: CommentModel, coordinator: FeedDetailCoordinator?, reloadSubject: PublishSubject<Void>?, updateCommentSubject: PublishSubject<CommentModel>?) {
        self.comment = comment
        self.coordinator = coordinator
        self.reloadSubject = reloadSubject
        self.updateCommentSubject = updateCommentSubject

        if comment.userProfile.isEmpty {
            userProfileImageView.image = Common.getDefaultProfileImage32(comment.userLevelTitle)
        } else {
            let imageURL = URL(string: comment.userProfile)
            userProfileImageView.kf.setImage(with: imageURL, options: [.transition(.fade(0.3))])
        }
        userNicknameLabel.text = comment.userNickname
        userLevelTitleLabel.text = comment.userLevelTitle
        commentLabel.text = comment.content == "" ? "내용이 입력되지 않은 댓글입니다." : comment.content
        createdDateLabel.text = comment.createdDate
        likeCountButton.setImage(UIImage(named: comment.isLike ? "likeFilled12Px" : "likeOutline12Px"), for: .normal)
        likeCountButton.setTitle("\(comment.likeCount)", for: .normal)

        likeCountButton.rx.tap
            .subscribe(onNext: { [weak self] in
                APIClient.checkLogin(loginToken: UserDataManager.sharedInstance.loginToken) { [weak self] userModel in
                    if userModel.id == 0 {
                        self?.coordinator?.presentLogin()
                    } else {
                        guard let commentID = self?.comment?.id else { return }

                        if self?.likeCountButton.currentImage?.isEqual(UIImage(named: "likeOutline12Px")) ?? false {
                            APIClient.likeComment(commentID: commentID) { [weak self] isSuccess in
                                if isSuccess {
                                    self?.likeCountButton.setImage(UIImage(named: "likeFilled12Px"), for: .normal)
                                    let likeCount = Int(self?.likeCountButton.title(for: .normal) ?? "0") ?? 0
                                    self?.likeCountButton.setTitle("\(likeCount+1)", for: .normal)
                                    Common.hapticVibration()
                                }
                            }
                        } else {
                            APIClient.deleteCommentLike(commentID: commentID) { [weak self] isSuccess in
                                if isSuccess {
                                    self?.likeCountButton.setImage(UIImage(named: "likeOutline12Px"), for: .normal)
                                    let likeCount = Int(self?.likeCountButton.title(for: .normal) ?? "0") ?? 0
                                    self?.likeCountButton.setTitle("\(likeCount-1)", for: .normal)
                                    Common.hapticVibration()
                                }
                            }
                        }
                    }
                }
            })
            .disposed(by: disposeBag)

        moreButton.rx.tap
            .subscribe(onNext: { [weak self] in
                if comment.userID == UserDataManager.sharedInstance.userID {
                    self?.clickedMyReplyCommentMore()
                } else {
                    self?.clickedOthersReplyCommentMore()
                }
            })
            .disposed(by: disposeBag)
    }

    private func clickedMyReplyCommentMore() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: "수정하기", style: .default, handler:{ [weak self] (UIAlertAction) in
            if let comment = self?.comment {
                self?.updateCommentSubject?.onNext(comment)
            }
        }))

        alert.addAction(UIAlertAction(title: "삭제하기", style: .destructive, handler:{ [weak self] (UIAlertAction) in
            self?.coordinator?.presentDeleteCommentPopup(commentID: self?.comment?.id ?? 0, reloadSubject: self?.reloadSubject ?? PublishSubject<Void>())
        }))

        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler:{ (UIAlertAction) in
            print("취소")
        }))

        self.coordinator?.presenter.present(alert, animated: true, completion: {
            print("completion block")
        })
    }

    private func clickedOthersReplyCommentMore() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: "신고하기", style: .default, handler: { [weak self] (UIAlertAction) in
            guard let commentID = self?.comment?.id else { return }
            self?.coordinator?.presentReportCommentPopup(commentID: commentID)
        }))

        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: { (UIAlertAction) in
            print("취소")
        }))

        self.coordinator?.presenter.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
}
