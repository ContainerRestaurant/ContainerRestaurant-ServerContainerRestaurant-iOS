//
//  InquiryProfileViewController.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/05/12.
//

import UIKit

class InquiryProfileViewController: BaseViewController, Storyboard, UINavigationBarDelegate {
    weak var coordinator: InquiryProfileCoordinator?
    var userData: UserModel = UserModel()
    var userFeed: [FeedPreviewModel] = []

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNicknameLabel: UILabel!
    @IBOutlet weak var userLevelLabel: UILabel!
    @IBOutlet weak var feedCountLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        setCollectionView()
        bindingView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setNavigation()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        HomeViewController.homeNavigationBarAnimated = true
    }

    private func setCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self

        collectionView.register(TwoFeedInLineCollectionView.self)
    }
    
    private func setNavigation() {
        self.coordinator?.presenter.navigationBar.barTintColor = .white
        self.coordinator?.presenter.navigationBar.tintColor = .colorGrayGray08
        self.coordinator?.presenter.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.colorGrayGray08]
        self.coordinator?.presenter.navigationBar.isTranslucent = false
        self.coordinator?.presenter.navigationBar.topItem?.title = ""
        self.navigationItem.title = "프로필 조회"
    }

    private func bindingView() {
        if userData.profile.isEmpty {
            profileImageView.image = Common.getDefaultProfileImage42(userData.levelTitle)
        } else {
            profileImageView.kf.setImage(with: URL(string: userData.profile), options: [.transition(.fade(0.3))])
        }
        userNicknameLabel.text = userData.nickname
        userLevelLabel.text = userData.levelTitle
        feedCountLabel.text = "\(userData.feedCount)회"
    }
    
    deinit {
        print("InquiryProfileViewController Deinit")
    }
}

extension InquiryProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: TwoFeedInLineCollectionView = collectionView.dequeueReusableCell(for: indexPath)
        if let coordinator = self.coordinator {
            cell.configureUserFeed(userFeed, coordinator)
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height: CGFloat = { () -> CGFloat in
            if userFeed.count > 0 {
                let lineCount = round(Double(self.userFeed.count)/2.0)
                var cellHeight: CGFloat = 273 * CGFloat(lineCount)
                if lineCount > 0 { cellHeight += 20 * CGFloat(lineCount-1) }

                return cellHeight
            } else {
                return CGFloat(285)
            }
        }()

        return CGSize(width: UIScreen.main.bounds.width, height: height)
    }
}
