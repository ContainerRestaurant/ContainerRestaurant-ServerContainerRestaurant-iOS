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
        mainProfileImageView.image = Common.getMainProfileImage(homeMainData.myLevelTitle)

        if homeMainData.myProfile.isEmpty {
            myProfileImageView.image = Common.getDefaultProfileImage36(homeMainData.myLevelTitle)
        } else {
            myProfileImageView.kf.setImage(with: URL(string: homeMainData.myProfile), options: [.transition(.fade(0.3))])
        }

        for (index, user) in homeMainData.latestWriterProfile.enumerated() {
            if user.profile.isEmpty {
                switch index {
                case 0: firstContainerOfEveryoneImageView.image = Common.getDefaultProfileImage36(user.levelTitle)
                case 1: secondContainerOfEveryoneImageView.image = Common.getDefaultProfileImage36(user.levelTitle)
                case 2: thirdContainerOfEveryoneImageView.image = Common.getDefaultProfileImage36(user.levelTitle)
                default: break
                }
            } else {
                switch index {
                case 0: firstContainerOfEveryoneImageView.kf.setImage(with: URL(string: user.profile), options: [.transition(.fade(0.3))])
                case 1: secondContainerOfEveryoneImageView.kf.setImage(with: URL(string: user.profile), options: [.transition(.fade(0.3))])
                case 2: thirdContainerOfEveryoneImageView.kf.setImage(with: URL(string: user.profile), options: [.transition(.fade(0.3))])
                default: break
                }
            }
        }

        myContainerCountLabel.text = String(homeMainData.myContainer)
        containerOfEveryoneCountLabel.text = String(homeMainData.totalContainer)

        myContainerButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                APIClient.checkLogin(loginToken: UserDataManager.sharedInstance.loginToken) { [weak self] user in
                    if user.id == 0 {
                        self?.coordinator?.presentCreationPopup()
                    } else {
                        self?.coordinator?.pushToInquiryProfile(userID: UserDataManager.sharedInstance.userID)
                    }
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
