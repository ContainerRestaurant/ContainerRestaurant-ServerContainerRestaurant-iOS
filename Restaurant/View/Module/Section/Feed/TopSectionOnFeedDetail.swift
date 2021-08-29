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
    var disposeBag = DisposeBag()

    @IBOutlet weak var feedImageView: UIImageView!
    @IBOutlet weak var userProfileImageView: UIImageView!
    @IBOutlet weak var userNicknameLabel: UILabel!
    @IBOutlet weak var userLevelLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var bookmarkButton: UIButton!
    @IBOutlet weak var bookmarkCountLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configure(_ thumbnailURLObservable: Observable<String>, _ userProfileImageObservable: Observable<String>, _ userNicknameDriver: Driver<String>, _ userLevelDriver: Driver<String>, _ likeCountDriver: Driver<Int>, _ scrapCountDriver: Driver<Int>, _ userLevel: String) {
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
    }
}
