//
//  FeedDetailViewController.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/07/14.
//

import UIKit
import RxSwift

enum FeedDetailTap {
    case information
    case content
}

class FeedDetailViewController: BaseViewController, Storyboard, ViewModelBindableType {
    var viewModel: FeedDetailViewModel!
    weak var coordinator: FeedDetailCoordinator?
    var selectedTapTypeSubject = PublishSubject<FeedDetailTap>()
    var selectedTapType: FeedDetailTap = .information
    
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

        selectedTapTypeSubject
            .subscribe(onNext: { [weak self] type in
                self?.selectedTapType = type

                switch type {
                case .information:
                    self?.viewModel.setInformationModules()
                case .content: break
                }

                self?.collectionView.reloadData()
            })
            .disposed(by: disposeBag)

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

        viewModel.thumbnailURLObservable
            .map { URL(string: $0) }
            .subscribe(onNext: { [weak self] imageURL in
                self?.feedImageView.kf.setImage(with: imageURL, options: [.transition(.fade(0.3))])
            })
            .disposed(by: disposeBag)

        viewModel.userNicknameDriver
            .drive(userNicknameLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.contentObservable
            .map { $0.isEmpty }
            .subscribe(onNext: { [weak self] isEmptyContent in
                if isEmptyContent {
                    self?.selectedTapTypeSubject.onNext(.information)
                    self?.setOnlyInformationTap()
                } else {
                    self?.selectedTapTypeSubject.onNext(.content)
                    self?.setContentTapAndInformationTap()
                }
            })
            .disposed(by: disposeBag)

        informationTapButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.isSelectedInformationTap()
                self?.selectedTapTypeSubject.onNext(.information)
            })
            .disposed(by: disposeBag)

        contentTapButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.isSelectedContentTap()
                self?.selectedTapTypeSubject.onNext(.content)
            })
            .disposed(by: disposeBag)
    }
}

//MARK: - Instance Method
extension FeedDetailViewController {
    private func setCollectionView() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.collectionView.register(RestaurantInformationOnFeedDetail.self)
        self.collectionView.register(LevelOfDifficultyOnFeedDetail.self)
        self.collectionView.register(MenuOnFeedDetail.self)
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
        return viewModel.modules.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if self.selectedTapType == .information {
            switch viewModel.modules[indexPath.row] {
            case is RestaurantInformationOnFeedDetail.Type:
                let cell: RestaurantInformationOnFeedDetail = collectionView.dequeueReusableCell(for: indexPath)
                cell.configure(category: viewModel.categoryDriver, restaurantName: viewModel.restaurantNameDriver, isWelcome: viewModel.isWelcomeDriver)
                return cell

            case is LevelOfDifficultyOnFeedDetail.Type:
                let cell: LevelOfDifficultyOnFeedDetail = collectionView.dequeueReusableCell(for: indexPath)
                cell.configure(levelOfDifficulty: viewModel.levelOfDifficulty)
                return cell

            case is MenuOnFeedDetail.Type:
                let cell: MenuOnFeedDetail = collectionView.dequeueReusableCell(for: indexPath)
                cell.mainMenuConfigure(menuAndContainers: viewModel.mainMenuAndContainers)
                return cell

            default: return UICollectionViewCell()
            }
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if self.selectedTapType == .information {
            switch viewModel.modules[indexPath.row] {
            case is RestaurantInformationOnFeedDetail.Type: return CGSize(width: UIScreen.main.bounds.width, height: CGFloat(viewModel.isWelcome ? 123 : 91))

            case is LevelOfDifficultyOnFeedDetail.Type:
                return CGSize(width: UIScreen.main.bounds.width, height: CGFloat(84))

            case is MenuOnFeedDetail.Type:
                var cellHeight = CGFloat(110)
                if viewModel.mainMenuAndContainers.count > 1 {
                    cellHeight += CGFloat(64 * (viewModel.mainMenuAndContainers.count - 1))
                }
                return CGSize(width: UIScreen.main.bounds.width, height: cellHeight)

            default: return .zero
            }
        } else {
            return .zero
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }
}
