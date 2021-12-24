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

    func configure(_ coordinator: FeedDetailCoordinator?, _ feedID: String, _ thumbnailURLObservable: Observable<String>, _ userProfileImageObservable: Observable<String>, _ userNicknameDriver: Driver<String>, _ userLevelDriver: Driver<String>, _ likeCountDriver: Driver<Int>, _ scrapCountDriver: Driver<Int>, _ userLevel: String, _ isLike: Observable<Bool>, _ isScrap: Observable<Bool>, _ userID: Int, selectedCell: TwoFeedCollectionViewCell) {
        self.coordinator = coordinator
        self.userID = userID

        thumbnailURLObservable
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

        userProfileImageObservable
            .map { URL(string: $0) }
            .subscribe(onNext: { [weak self] imageURL in
                if let imageURL = imageURL {
                    self?.userProfileImageView.kf.setImage(with: imageURL, options: [.transition(.fade(0.3))])
                } else {
                    self?.userProfileImageView.image = Common.getDefaultProfileImage36(userLevel)
                }
            })
            .disposed(by: disposeBag)

        userNicknameDriver
            .drive(userNicknameLabel.rx.text)
            .disposed(by: disposeBag)

        userLevelDriver
            .drive(userLevelLabel.rx.text)
            .disposed(by: disposeBag)

        likeCountDriver
            .map { String($0) }
            .drive(likeCountLabel.rx.text)
            .disposed(by: disposeBag)

        scrapCountDriver
            .map { String($0) }
            .drive(bookmarkCountLabel.rx.text)
            .disposed(by: disposeBag)

        isLike
            .subscribe(onNext: { [weak self] isLike in
                self?.isLiked = isLike
                self?.likeButton.setImage(UIImage(named: isLike ? "likeFilled20Px" : "likeOutlineGray20Px"), for: .normal)
            })
            .disposed(by: disposeBag)

        isScrap
            .subscribe(onNext: { [weak self] isScrap in
                self?.isScraped = isScrap
                self?.bookmarkButton.setImage(UIImage(named: isScrap ? "bookmarkFilled20px" : "bookmarkOutlineGray20px" ), for: .normal)
            })
            .disposed(by: disposeBag)

        likeButton.rx.tap
            .bind { [weak self] in self?.likeAction(coordinator, Int(feedID) ?? -1, selectedCell as! TwoFeedCollectionViewCell) }
            .disposed(by: disposeBag)

        bookmarkButton.rx.tap
            .bind { [weak self] in self?.bookmarkAction(coordinator, Int(feedID) ?? -1) }
            .disposed(by: disposeBag)
    }

    private func likeAction(_ coordinator: FeedDetailCoordinator?, _ feedID: Int, _ selectedCell: TwoFeedCollectionViewCell) {
        APIClient.checkLogin(loginToken: UserDataManager.sharedInstance.loginToken) { [weak self] userModel in
            if userModel.id == 0 {
                coordinator?.presentLogin()
            } else {
                guard let isLiked = self?.isLiked else { return }
                APIClient.likeFeed(feedID: feedID, cancel: isLiked)
                self?.likeButton.setImage(UIImage(named: isLiked ? "likeOutlineGray20Px" : "likeFilled20Px"), for: .normal)
                selectedCell.likeButton.setImage(UIImage(named: isLiked ? "likeOutlineGray20Px" : "likeFilled20Px"), for: .normal)

                let likedCount = self?.likeCountLabel.text ?? "0"
                let likedCountInt = isLiked ? (Int(likedCount) ?? 0) - 1 : (Int(likedCount) ?? 0) + 1
                self?.likeCountLabel.text = "\(likedCountInt)"
                selectedCell.likeCountLabel.text = "\(likedCountInt)"

                self?.isLiked = !isLiked
                Common.hapticVibration()
            }
        }
    }

    private func bookmarkAction(_ coordinator: FeedDetailCoordinator?, _ feedID: Int) {
        APIClient.checkLogin(loginToken: UserDataManager.sharedInstance.loginToken) { [weak self] userModel in
            if userModel.id == 0 {
                coordinator?.presentLogin()
            } else {
                guard let isScraped = self?.isScraped else { return }
                APIClient.scrapFeed(feedID: feedID, cancel: isScraped)
                self?.bookmarkButton.setImage(UIImage(named: isScraped ? "bookmarkOutlineGray20px" : "bookmarkFilled20px"), for: .normal)

                let scrapedCount = self?.bookmarkCountLabel.text ?? "0"
                let scrapedCountInt = isScraped ? (Int(scrapedCount) ?? 0) - 1 : (Int(scrapedCount) ?? 0) + 1
                self?.bookmarkCountLabel.text = "\(scrapedCountInt)"

                self?.isScraped = !isScraped
                Common.hapticVibration()
            }
        }
    }
}
