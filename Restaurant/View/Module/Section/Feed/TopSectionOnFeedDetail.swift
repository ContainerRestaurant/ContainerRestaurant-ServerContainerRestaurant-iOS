//
//  TopSectionOnFeedDetail.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/08/16.
//

import UIKit
import RxSwift
import RxCocoa

class TopSectionOnFeedDetail: UICollectionViewCell {
    weak var coordinator: FeedDetailCoordinator?
    var userID: Int?
    var disposeBag = DisposeBag()
    var isLiked: Bool?
    var isScraped: Bool?

    @IBOutlet weak var feedImageView: UIImageView!
    @IBOutlet weak var feedImageButton: UIButton!
    @IBOutlet weak var userProfileImageView: UIImageView!
    @IBOutlet weak var userNicknameLabel: UILabel!
    @IBOutlet weak var userLevelLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var bookmarkButton: UIButton!
    @IBOutlet weak var bookmarkCountLabel: UILabel!
    @IBAction func clickedUserProfileImage(_ sender: Any) {
        if let userID = self.userID {
            coordinator?.pushToInquiryProfile(userID: userID)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configure(_ coordinator: FeedDetailCoordinator?, _ viewModel: FeedDetailViewModel, selectedCell: TwoFeedCollectionViewCell) {
        self.coordinator = coordinator
        self.userID = viewModel.feedDetail.userID

        viewModel.thumbnailURLObservable
            .map { URL(string: $0) }
            .subscribe(onNext: { [weak self] imageURL in
                if let imageURL = imageURL {
                    self?.feedImageView.kf.setImage(with: imageURL, options: [.transition(.fade(0.3))])
                } else {
                    self?.feedImageView.image = UIImage(named: "emptyImgFeedDetail")
                    self?.feedImageView.backgroundColor = FeedBackgroundColor.allCases.randomElement()?.color()
                }
            })
            .disposed(by: disposeBag)

        viewModel.userProfileImageObservable
            .map { URL(string: $0) }
            .subscribe(onNext: { [weak self] imageURL in
                if let imageURL = imageURL {
                    self?.userProfileImageView.kf.setImage(with: imageURL, options: [.transition(.fade(0.3))])
                } else {
                    self?.userProfileImageView.image = Common.getDefaultProfileImage36(viewModel.feedDetail.userLevel)
                }
            })
            .disposed(by: disposeBag)

        viewModel.userNicknameDriver
            .drive(userNicknameLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.userLevelDriver
            .drive(userLevelLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.isLikeSubject
            .subscribe(onNext: { [weak self] isLike in
                self?.isLiked = isLike
                self?.likeButton.setImage(UIImage(named: isLike ? "likeFilled20Px" : "likeOutlineGray20Px"), for: .normal)
            })
            .disposed(by: disposeBag)

        viewModel.likeCountSubject
            .map { String($0) }
            .bind(to: likeCountLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.isScrapSubject
            .subscribe(onNext: { [weak self] isScrap in
                self?.isScraped = isScrap
                self?.bookmarkButton.setImage(UIImage(named: isScrap ? "bookmarkFilled20px" : "bookmarkOutlineGray20px" ), for: .normal)
            })
            .disposed(by: disposeBag)

        viewModel.scrapCountSubject
            .map { String($0) }
            .bind(to: bookmarkCountLabel.rx.text)
            .disposed(by: disposeBag)

        feedImageButton.rx.tap
            .bind { [weak self] in
                guard let image = self?.feedImageView.image else { return }
                self?.coordinator?.presentImagePopup(image: image)
            }
            .disposed(by: disposeBag)

        likeButton.rx.tap
            .bind { [weak self] in self?.likeAction(coordinator, viewModel, selectedCell) }
            .disposed(by: disposeBag)

        bookmarkButton.rx.tap
            .bind { [weak self] in self?.bookmarkAction(coordinator, viewModel) }
            .disposed(by: disposeBag)
    }

    private func likeAction(_ coordinator: FeedDetailCoordinator?, _ viewModel: FeedDetailViewModel, _ selectedCell: TwoFeedCollectionViewCell) {
        APIClient.checkLogin(loginToken: UserDataManager.sharedInstance.loginToken) { [weak self] userModel in
            if userModel.id == 0 {
                coordinator?.presentLogin()
            } else {
                guard let isLiked = self?.isLiked else { return }

                APIClient.likeFeed(feedID: viewModel.feedDetail.id, cancel: isLiked)

                let likeImage = UIImage(named: isLiked ? "likeOutlineGray20Px" : "likeFilled20Px")
                selectedCell.likeButton.setImage(likeImage, for: .normal)

                let likedCount = self?.likeCountLabel.text ?? "0"
                let likedCountInt = isLiked ? (Int(likedCount) ?? 0) - 1 : (Int(likedCount) ?? 0) + 1
                selectedCell.likeCountLabel.text = "\(likedCountInt)"

                viewModel.isLikeSubject.onNext(!isLiked)
                viewModel.likeCountSubject.onNext(likedCountInt)

                Common.hapticVibration()
            }
        }
    }

    private func bookmarkAction(_ coordinator: FeedDetailCoordinator?, _ viewModel: FeedDetailViewModel) {
        APIClient.checkLogin(loginToken: UserDataManager.sharedInstance.loginToken) { [weak self] userModel in
            if userModel.id == 0 {
                coordinator?.presentLogin()
            } else {
                guard let isScraped = self?.isScraped else { return }

                APIClient.scrapFeed(feedID: viewModel.feedDetail.id, cancel: isScraped)

                let bookmarkImage = UIImage(named: isScraped ? "bookmarkOutlineGray20px" : "bookmarkFilled20px")
                self?.bookmarkButton.setImage(bookmarkImage, for: .normal)

                let scrapedCount = self?.bookmarkCountLabel.text ?? "0"
                let scrapedCountInt = isScraped ? (Int(scrapedCount) ?? 0) - 1 : (Int(scrapedCount) ?? 0) + 1
                self?.bookmarkCountLabel.text = "\(scrapedCountInt)"

                viewModel.isScrapSubject.onNext(!isScraped)
                viewModel.scrapCountSubject.onNext(scrapedCountInt)

                Common.hapticVibration()
            }
        }
    }
}
