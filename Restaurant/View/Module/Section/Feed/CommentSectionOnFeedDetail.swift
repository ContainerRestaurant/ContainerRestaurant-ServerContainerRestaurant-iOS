//
//  CommentSectionOnFeedDetail.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/08/31.
//

import UIKit
import RxSwift

class CommentSectionOnFeedDetail: UICollectionViewCell {
    var coordinator: FeedDetailCoordinator?
    var comments: [CommentModel] = []
    var isReplyCommentSubject = PublishSubject<Int>()
    var reloadSubject = PublishSubject<Void>()

    var disposeBag = DisposeBag()

    @IBOutlet weak var commentTitleView: UIView!
    @IBOutlet weak var commentCountLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var emptyCommentView: UIImageView!
    @IBOutlet weak var emptyCommentLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        commentTitleView.applySketchShadow(color: .colorGrayGray08, alpha: 0.05, x: 0, y: 2, blur: 4, spread: 0)
        collectionView.register(CommentOnFeedDetailCollectionViewCell.self)
        collectionView.register(DeletedCommentCollectionViewCell.self)
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        disposeBag = DisposeBag()
    }

    func configure(coordinator: FeedDetailCoordinator?, comments: [CommentModel], isReplyCommentSubject: PublishSubject<Int>, feedID: String) {
        self.coordinator = coordinator
        self.comments = comments
        self.isReplyCommentSubject = isReplyCommentSubject

        emptyCommentView.isHidden = !comments.isEmpty
        emptyCommentLabel.isHidden = !comments.isEmpty
        commentCountLabel.text = "\(comments.count)"
        collectionView.reloadData()

        reloadSubject.subscribe(onNext: { [weak self] in
            APIClient.commentsOfFeed(feedID: feedID) { [weak self] comments in
                self?.comments = comments
                self?.collectionView.reloadData()
            }
        })
        .disposed(by: disposeBag)
    }
}

extension CommentSectionOnFeedDetail: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comments.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let isDeletedComment = comments[indexPath.row].isDeleted
        if isDeletedComment {
            let cell: DeletedCommentCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.configure(coordinator: coordinator, comment: comments[indexPath.row], reloadSubject: reloadSubject)
            return cell
        } else {
            let cell: CommentOnFeedDetailCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.configure(coordinator: coordinator, comment: comments[indexPath.row], isReplyCommentSubject: isReplyCommentSubject, reloadSubject: reloadSubject)
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let isDeletedComment = comments[indexPath.row].isDeleted
        if isDeletedComment {
            let cellHeightWithoutReplyComment = CGFloat(54)
            var replyCommentHeight = CGFloat(0)
            for (index, replyComment) in comments[indexPath.row].replyComment.enumerated() {
                if index > 0 {
                    let separateHeight = CGFloat(18)
                    replyCommentHeight += separateHeight
                }
                let cellHeightWithoutReplyComment = CGFloat(86)
                var replyCommentLabelHeight = Common.labelHeight(text: replyComment.content, font: .systemFont(ofSize: 12), width: CGFloat(235).widthRatio())
                if replyCommentLabelHeight == 0 {
                    replyCommentLabelHeight = 14
                }
                replyCommentHeight += (cellHeightWithoutReplyComment + replyCommentLabelHeight)
            }

            return CGSize(width: UIScreen.main.bounds.width, height: cellHeightWithoutReplyComment + replyCommentHeight)
        } else {
            let cellHeightWithoutComment = CGFloat(101)
            var commentLabelHeight = Common.labelHeight(text: comments[indexPath.row].content, font: .systemFont(ofSize: 12), width: CGFloat(301).widthRatio())
            if commentLabelHeight == 0 {
                commentLabelHeight = 14
            }

            var replyCommentHeight = CGFloat(0)
            for (index, replyComment) in comments[indexPath.row].replyComment.enumerated() {
                if index > 0 {
                    let separateHeight = CGFloat(18)
                    replyCommentHeight += separateHeight
                }
                let cellHeightWithoutReplyComment = CGFloat(86)
                var replyCommentLabelHeight = Common.labelHeight(text: replyComment.content, font: .systemFont(ofSize: 12), width: CGFloat(235).widthRatio())
                if replyCommentLabelHeight == 0 {
                    replyCommentLabelHeight = 14
                }
                replyCommentHeight += (cellHeightWithoutReplyComment + replyCommentLabelHeight)
            }

            let cellHeight = cellHeightWithoutComment + commentLabelHeight + replyCommentHeight

            return CGSize(width: UIScreen.main.bounds.width, height: cellHeight)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }
}
