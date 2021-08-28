//
//  TapOnFeedDetail.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/08/16.
//

import UIKit
import RxSwift
import RxCocoa

class TapOnFeedDetail: UICollectionViewCell {
    var disposeBag = DisposeBag()
    var firstEntry = true

    @IBOutlet weak var contentTapView: UIView!
    @IBOutlet weak var contentTapButton: UIButton!
    @IBOutlet weak var contentTapLabel: UILabel!
    @IBOutlet weak var contentTapUnderLineView: UIView!

    @IBOutlet weak var informationTapView: UIView!
    @IBOutlet weak var informationTapButton: UIButton!
    @IBOutlet weak var informationTapLabel: UILabel!
    @IBOutlet weak var informationTapUnderLineView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        disposeBag = DisposeBag()
    }

    func configure(_ content: String, _ selectedTapType: FeedDetailTap, _ selectedTapTypeSubject: PublishSubject<FeedDetailTap>) {
        if firstEntry {
            content.isEmpty ? self.setOnlyInformationTap() : self.setContentTapAndInformationTap()
            firstEntry = false
        }

        informationTapButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.isSelectedInformationTap()
                selectedTapTypeSubject.onNext(.information)
            })
            .disposed(by: disposeBag)

        contentTapButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.isSelectedContentTap()
                selectedTapTypeSubject.onNext(.content)
            })
            .disposed(by: disposeBag)
    }
}

//MARK: - Instance Method
extension TapOnFeedDetail {
    private func setOnlyInformationTap() {
        self.contentTapView.isHidden = true
    }

    private func setContentTapAndInformationTap() {
        self.informationTapLabel.font = .systemFont(ofSize: 14)
        self.informationTapLabel.textColor = .colorGrayGray05
        self.informationTapUnderLineView.isHidden = true
    }

    private func isSelectedInformationTap() {
        self.informationTapLabel.font = .boldSystemFont(ofSize: 14)
        self.informationTapLabel.textColor = .colorGrayGray07
        self.informationTapUnderLineView.isHidden = false

        self.contentTapLabel.font = .systemFont(ofSize: 14)
        self.contentTapLabel.textColor = .colorGrayGray05
        self.contentTapUnderLineView.isHidden = true
    }

    private func isSelectedContentTap() {
        self.contentTapLabel.font = .boldSystemFont(ofSize: 14)
        self.contentTapLabel.textColor = .colorGrayGray07
        self.contentTapUnderLineView.isHidden = false

        self.informationTapLabel.font = .systemFont(ofSize: 14)
        self.informationTapLabel.textColor = .colorGrayGray05
        self.informationTapUnderLineView.isHidden = true
    }
}
