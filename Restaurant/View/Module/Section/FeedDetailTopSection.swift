//
//  FeedDetailTopSection.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/07/14.
//

import UIKit
import RxSwift
import RxCocoa

class FeedDetailTopSection: UICollectionViewCell {
    var disposeBag = DisposeBag()
    
    @IBOutlet weak var userNicknameLabel: UILabel!
    @IBOutlet weak var feedImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(userNickname: Driver<String>, thumbnailURL: Observable<String>, likeCount: Driver<Int>, scrapCount: Driver<Int>) {
        userNickname
            .drive(userNicknameLabel.rx.text)
            .disposed(by: disposeBag)
        
        thumbnailURL
            .map { URL(string: $0) }
            .subscribe(onNext: { [weak self] imageURL in
                self?.feedImageView.kf.setImage(with: imageURL, options: [.transition(.fade(0.3))])
            })
            .disposed(by: disposeBag)
    }
}
