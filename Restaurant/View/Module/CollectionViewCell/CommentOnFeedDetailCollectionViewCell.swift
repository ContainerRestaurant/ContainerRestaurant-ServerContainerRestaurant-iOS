//
//  CommentOnFeedDetailCollectionViewCell.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/08/31.
//

import UIKit
import RxSwift

class CommentOnFeedDetailCollectionViewCell: UICollectionViewCell {
    var comment: CommentModel?
    var isReplyCommentSubject = PublishSubject<Int>()
    var disposeBag = DisposeBag()

    @IBOutlet weak var userProfileImageView: UIImageView!
    @IBOutlet weak var userNicknameLabel: UILabel!
    @IBOutlet weak var userLevelTitleLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var createdDateLabel: UILabel!
    @IBOutlet weak var likeCountButton: UIButton!
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var replyCommentCollectionView: UICollectionView!

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

    func configure(comment: CommentModel, isReplyCommentSubject: PublishSubject<Int>) {
        self.comment = comment
        self.isReplyCommentSubject = isReplyCommentSubject

        userProfileImageView.image = Common.getDefaultProfileImage32(comment.userLevelTitle)
        userNicknameLabel.text = comment.userNickname
        userLevelTitleLabel.text = comment.userLevelTitle
        commentLabel.text = comment.content == "" ? "내용이 입력되지 않은 댓글입니다." : comment.content
        createdDateLabel.text = comment.createdDate
        likeCountButton.setTitle("\(comment.likeCount)", for: .normal)

        replyButton.rx.tap
            .subscribe(onNext: { [weak self] in
                if let commentID = self?.comment?.id {
                    self?.isReplyCommentSubject.onNext(commentID)
                }
            })
            .disposed(by: disposeBag)

        replyCommentCollectionView.reloadData()
    }
}

extension CommentOnFeedDetailCollectionViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comment?.replyComment.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ReplyCommentOnFeedDetailCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        if let replyComment = comment?.replyComment[indexPath.row] {
            cell.configure(comment: replyComment)
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

