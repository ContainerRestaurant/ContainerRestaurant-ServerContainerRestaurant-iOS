//
//  FeedDetailViewController.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/07/14.
//

import UIKit

class FeedDetailViewController: BaseViewController, Storyboard, ViewModelBindableType {
    var viewModel: FeedDetailViewModel!
    weak var coordinator: FeedDetailCoordinator?
    
    @IBOutlet weak var feedImageView: UIImageView!
    @IBOutlet weak var userNicknameLabel: UILabel!
    @IBOutlet weak var userLevelLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var bookmarkButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!

    @IBOutlet weak var contentTapView: UIView!
    @IBOutlet weak var contentTapButton: UIButton!
    @IBOutlet weak var contentTapLabel: UILabel!
    @IBOutlet weak var contentTapUnderLineView: UIView!

    @IBOutlet weak var informationTapView: UIView!
    @IBOutlet weak var informationTapButton: UIButton!
    @IBOutlet weak var informationTapLabel: UILabel!
    @IBOutlet weak var informationTapUnderLineView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setCollectionView()
        print("FeedDetailViewController viewDidLoad()")
    }
    
    deinit {
        print("FeedDetailViewController Deinit")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setNavigation()
    }
    
    func bindingView() {
        print("FeedDetail bindingView()")

        viewModel.thumbnailURL
            .map { URL(string: $0) }
            .subscribe(onNext: { [weak self] imageURL in
                self?.feedImageView.kf.setImage(with: imageURL, options: [.transition(.fade(0.3))])
            })
            .disposed(by: disposeBag)

        viewModel.userNickname
            .drive(userNicknameLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.content
            .map { $0.isEmpty }
            .subscribe(onNext: { [weak self] isEmptyContent in
                isEmptyContent ? self?.setOnlyInformationTap() : self?.setContentTapAndInformationTap()
            })
            .disposed(by: disposeBag)

        informationTapButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.isSelectedInformationTap()
            })
            .disposed(by: disposeBag)

        contentTapButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.isSelectedContentTap()
            })
            .disposed(by: disposeBag)
    }
}

//MARK: - Instance Method
extension FeedDetailViewController {
    private func setCollectionView() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
//        self.collectionView.register(FeedDetailTopSection.self)
    }
    
    private func setNavigation() {
        let backImage = UIImage(named: "chevronLeftOutline20Px")
        self.coordinator?.presenter.navigationBar.backIndicatorImage = backImage
        self.coordinator?.presenter.navigationBar.backIndicatorTransitionMaskImage = backImage
        
        self.coordinator?.presenter.navigationBar.barTintColor = .white
        self.coordinator?.presenter.navigationBar.tintColor = .colorGrayGray08
        self.coordinator?.presenter.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.colorGrayGray08]
        self.coordinator?.presenter.navigationBar.isTranslucent = false
        self.coordinator?.presenter.navigationBar.topItem?.title = ""
    }

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

extension FeedDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.row {
        case 0: return CGSize(width: UIScreen.main.bounds.width, height: CGFloat(328))
        default: return .zero
        }
    }
}
