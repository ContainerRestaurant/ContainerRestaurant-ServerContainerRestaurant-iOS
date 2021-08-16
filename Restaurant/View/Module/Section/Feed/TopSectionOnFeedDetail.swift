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
    @IBOutlet weak var userNicknameLabel: UILabel!
    @IBOutlet weak var userLevelLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var bookmarkButton: UIButton!
    @IBOutlet weak var bookmarkCountLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configure(_ thumbnailURLObservable: Observable<String>, _ userNicknameDriver: Driver<String>, _ likeCountDriver: Driver<Int>, _ scrapCountDriver: Driver<Int>) {
        thumbnailURLObservable
            .map { URL(string: $0) }
            .subscribe(onNext: { [weak self] imageURL in
                self?.feedImageView.kf.setImage(with: imageURL, options: [.transition(.fade(0.3))])
            })
            .disposed(by: disposeBag)

        userNicknameDriver
            .drive(userNicknameLabel.rx.text)
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
