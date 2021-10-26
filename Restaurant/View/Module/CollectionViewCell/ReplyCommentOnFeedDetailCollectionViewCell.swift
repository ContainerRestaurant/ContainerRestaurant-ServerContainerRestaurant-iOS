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

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configure(comment: CommentModel, coordinator: FeedDetailCoordinator?, reloadSubject: PublishSubject<Void>?, updateCommentSubject: PublishSubject<CommentModel>?) {
        self.comment = comment
        self.coordinator = coordinator
        self.reloadSubject = reloadSubject
        self.updateCommentSubject = updateCommentSubject

        userProfileImageView.image = Common.getDefaultProfileImage32(comment.userLevelTitle)
        userNicknameLabel.text = comment.userNickname
        userLevelTitleLabel.text = comment.userLevelTitle
        commentLabel.text = comment.content == "" ? "내용이 입력되지 않은 댓글입니다." : comment.content
        createdDateLabel.text = comment.createdDate
        likeCountButton.setTitle("\(comment.likeCount)", for: .normal)

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

        alert.addAction(UIAlertAction(title: "수정하기", style: .default , handler:{ [weak self] (UIAlertAction) in
            if let comment = self?.comment {
                self?.updateCommentSubject?.onNext(comment)
            }
        }))

        alert.addAction(UIAlertAction(title: "삭제하기", style: .destructive , handler:{ [weak self] (UIAlertAction) in
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

    }
}
