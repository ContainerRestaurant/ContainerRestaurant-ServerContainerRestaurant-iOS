//
//  DeletedCommentCollectionViewCell.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/10/25.
//

import UIKit
import RxSwift

class DeletedCommentCollectionViewCell: UICollectionViewCell {
    var coordiantor: FeedDetailCoordinator?
    var comment: CommentModel?
    var reloadSubject: PublishSubject<Void>?
    var updateCommentSubject: PublishSubject<CommentModel>?

    @IBOutlet weak var deletedCommentLabel: UILabel!
    @IBOutlet weak var replyCommentCollectionView: UICollectionView!

    override func awakeFromNib() {
        super.awakeFromNib()

        replyCommentCollectionView.register(ReplyCommentOnFeedDetailCollectionViewCell.self)
        replyCommentCollectionView.delegate = self
        replyCommentCollectionView.dataSource = self
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }

    func configure(coordinator: FeedDetailCoordinator?, comment: CommentModel, reloadSubject: PublishSubject<Void>?, updateCommentSubject: PublishSubject<CommentModel>?) {
        self.coordiantor = coordinator
        self.comment = comment
        self.reloadSubject = reloadSubject

        replyCommentCollectionView.reloadData()
    }
}

extension DeletedCommentCollectionViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comment?.replyComment.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ReplyCommentOnFeedDetailCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        if let replyComment = comment?.replyComment[indexPath.row] {
            cell.configure(comment: replyComment, coordinator: coordiantor, reloadSubject: reloadSubject, updateCommentSubject: updateCommentSubject)
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
