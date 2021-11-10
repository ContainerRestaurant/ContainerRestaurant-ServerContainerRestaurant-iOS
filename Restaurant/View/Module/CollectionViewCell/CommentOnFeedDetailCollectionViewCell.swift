//
//  CommentOnFeedDetailCollectionViewCell.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/08/31.
//

import UIKit
import RxSwift

class CommentOnFeedDetailCollectionViewCell: UICollectionViewCell {
    var coordinator: FeedDetailCoordinator?
    var comment: CommentModel?
    var isReplyCommentSubject: PublishSubject<CommentModel>?
    var reloadSubject = PublishSubject<Void>()
    var updateCommentSubject: PublishSubject<CommentModel>?
    var disposeBag = DisposeBag()

    @IBOutlet weak var userProfileImageView: UIImageView!
    @IBOutlet weak var userNicknameLabel: UILabel!
    @IBOutlet weak var userLevelTitleLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var createdDateLabel: UILabel!
    @IBOutlet weak var likeCountButton: UIButton!
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var replyCommentCollectionView: UICollectionView!
    @IBOutlet weak var moreButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()

        replyCommentCollectionView.register(ReplyCommentOnFeedDetailCollectionViewCell.self)
        replyCommentCollectionView.delegate = self
        replyCommentCollectionView.dataSource = self
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        disposeBag = DisposeBag()
    }

    func configure(coordinator: FeedDetailCoordinator?, comment: CommentModel, isReplyCommentSubject: PublishSubject<CommentModel>?, reloadSubject: PublishSubject<Void>, updateCommentSubject: PublishSubject<CommentModel>?) {
        self.coordinator = coordinator
        self.comment = comment
        self.isReplyCommentSubject = isReplyCommentSubject
        self.reloadSubject = reloadSubject
        self.updateCommentSubject = updateCommentSubject

        userProfileImageView.image = Common.getDefaultProfileImage32(comment.userLevelTitle)
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

        replyButton.rx.tap
            .subscribe(onNext: { [weak self] in
                if let comment = self?.comment {
                    self?.isReplyCommentSubject?.onNext(comment)
                }
            })
            .disposed(by: disposeBag)

        moreButton.rx.tap
            .subscribe(onNext: { [weak self] in
                if comment.userID == UserDataManager.sharedInstance.userID {
                    self?.clickedMyCommentMore()
                } else {
                    self?.clickedOthersCommentMore()
                }
            })
            .disposed(by: disposeBag)

        replyCommentCollectionView.reloadData()
    }

    private func clickedMyCommentMore() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: "수정하기", style: .default, handler:{ [weak self] (UIAlertAction) in
            if let comment = self?.comment {
                self?.updateCommentSubject?.onNext(comment)
            }
        }))

        alert.addAction(UIAlertAction(title: "삭제하기", style: .destructive, handler:{ [weak self] (UIAlertAction) in
            if let commentID = self?.comment?.id,
               let reloadSubject = self?.reloadSubject {
                self?.coordinator?.presentDeleteCommentPopup(commentID: commentID, reloadSubject: reloadSubject)
            }
        }))

        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler:{ (UIAlertAction) in
            print("취소")
        }))

        self.coordinator?.presenter.present(alert, animated: true, completion: {
            print("completion block")
        })
    }

    private func clickedOthersCommentMore() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: "신고하기", style: .default, handler: { [weak self] (UIAlertAction) in
            guard let commentID = self?.comment?.id else { return }
            self?.coordinator?.presentReportCommentPopup(commentID: commentID)
        }))

        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler:{ (UIAlertAction) in
            print("취소")
        }))

        self.coordinator?.presenter.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
}

extension CommentOnFeedDetailCollectionViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comment?.replyComment.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ReplyCommentOnFeedDetailCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        if let replyComment = comment?.replyComment[indexPath.row] {
            cell.configure(comment: replyComment, coordinator: coordinator, reloadSubject: reloadSubject, updateCommentSubject: updateCommentSubject)
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellHeightWidthoutComment = CGFloat(86)
        let commentHeight = Common.labelHeight(text: comment?.replyComment[indexPath.row].content ?? "", font: .systemFont(ofSize: 12), width: CGFloat(235).widthRatio())

        let cellHeight = cellHeightWidthoutComment + (commentHeight == 0 ? 14 : commentHeight)

        return CGSize(width: CGFloat(305).widthRatio(), height: cellHeight)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(18)
    }
}

