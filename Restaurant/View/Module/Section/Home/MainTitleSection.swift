//
//  MainTitleSection.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/04/26.
//

import UIKit
import RxSwift
import RxCocoa

class MainTitleSection: UICollectionViewCell {
    var disposeBag = DisposeBag()
    weak var coordinator: HomeCoordinator?
    var myContainerCount = 0
    
    @IBOutlet weak var mainPhraseLabel: UILabel!
    @IBOutlet weak var myLevelTitleLabel: UILabel!
    @IBOutlet weak var mainProfileImageView: UIImageView!
    @IBOutlet weak var myProfileImageView: UIImageView!
    @IBOutlet weak var myContainerCountLabel: UILabel!
    @IBOutlet weak var myContainerButton: UIButton!
    @IBOutlet weak var firstContainerOfEveryoneImageView: UIImageView!
    @IBOutlet weak var secondContainerOfEveryoneImageView: UIImageView!
    @IBOutlet weak var thirdContainerOfEveryoneImageView: UIImageView!
    @IBOutlet weak var containerOfEveryoneCountLabel: UILabel!
    @IBOutlet weak var containerOfEveryoneButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        disposeBag = DisposeBag()
    }
    
    func configure(coordinator: HomeCoordinator, homeMainData: HomeMainDataModel) {
        self.coordinator = coordinator
        self.myContainerCount = homeMainData.myContainer

        mainPhraseLabel.text = homeMainData.phrase
        myLevelTitleLabel.text = homeMainData.myLevelTitle

        if homeMainData.myProfile.isEmpty {
            myProfileImageView.image = UIImage(named: "ProfileTumbler36px")
        } else {
            myProfileImageView.kf.setImage(with: URL(string: homeMainData.myProfile), options: [.transition(.fade(0.3))])
        }

        for (index, imageURLString) in homeMainData.latestWriterProfile.enumerated() {
            if index == 0 {
                firstContainerOfEveryoneImageView.kf.setImage(with: URL(string: imageURLString), options: [.transition(.fade(0.3))])
            } else if index == 1 {
                secondContainerOfEveryoneImageView.kf.setImage(with: URL(string: imageURLString), options: [.transition(.fade(0.3))])
            } else if index == 2 {
                thirdContainerOfEveryoneImageView.kf.setImage(with: URL(string: imageURLString), options: [.transition(.fade(0.3))])
            }
        }

        myContainerCountLabel.text = String(homeMainData.myContainer)
        containerOfEveryoneCountLabel.text = String(homeMainData.totalContainer)

        myContainerButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                if self?.myContainerCount == 0 {
                    self?.coordinator?.presentCreationPopup()
                } else {
                    self?.coordinator?.pushToInquiryProfile(userID: UserDataManager.sharedInstance.userID)
                }
            })
            .disposed(by: disposeBag)

        containerOfEveryoneButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.coordinator?.pushToContainerOfEveryone()
            })
            .disposed(by: disposeBag)
    }
    
    deinit {
        print("MainTitleSection deinit")
    }
}
