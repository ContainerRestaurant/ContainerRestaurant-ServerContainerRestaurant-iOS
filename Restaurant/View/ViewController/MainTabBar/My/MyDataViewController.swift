//
//  MyDataViewController.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/09/28.
//

import UIKit

enum MyDataType {
    case myFeed
    case scrapedFeed
    case favoriteRestaurant
}

class MyDataViewController: BaseViewController, Storyboard, ViewModelBindableType {
    var viewModel: MyDataViewModel!
    weak var coordinator: MyDataCoordinator?
    var myDataType: MyDataType?

    @IBOutlet weak var collectionViewTopSpacing: NSLayoutConstraint!
    @IBOutlet weak var collectionViewLeftSpacing: NSLayoutConstraint!
    @IBOutlet weak var collectionViewRightSpacing: NSLayoutConstraint!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var emptyDataImageView: UIImageView!
    @IBOutlet weak var emptyDataLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        setCollectionView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setNavigation()
    }

    deinit {
        print("MyDataViewController Deinit")
    }

    func bindingView() {
        print("MyDataViewController bindingView")
    }
}

extension MyDataViewController {
    private func setCollectionView() {
        if myDataType == .myFeed || myDataType == .scrapedFeed {
            self.emptyDataImageView.isHidden = viewModel.feeds.count > 0
            self.emptyDataLabel.isHidden = viewModel.feeds.count > 0
            self.emptyDataLabel.text = myDataType == .myFeed ? "아직 용기낸 횟수가 없어요!" : "아직 스크랩한 피드가 없어요!"

            self.collectionViewTopSpacing.constant = 20
            self.collectionViewLeftSpacing.constant = 16
            self.collectionViewRightSpacing.constant = 16
        } else {
            self.emptyDataImageView.isHidden = viewModel.restaurants.count > 0
            self.emptyDataLabel.isHidden = viewModel.restaurants.count > 0
            self.emptyDataLabel.text = "아직 찜한 식당이 없어요!"

            self.collectionViewTopSpacing.constant = 16
            self.collectionViewLeftSpacing.constant = 0
            self.collectionViewRightSpacing.constant = 0
        }

        self.collectionView.delegate = self
        self.collectionView.dataSource = self

        self.collectionView.register(TwoFeedCollectionViewCell.self)
        self.collectionView.register(OneFeedCollectionViewCell.self)
    }

    private func setNavigation() {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        let backImage = UIImage(named: "chevronLeftOutline20Px")
        self.coordinator?.presenter.navigationBar.backIndicatorImage = backImage
        self.coordinator?.presenter.navigationBar.backIndicatorTransitionMaskImage = backImage
        self.coordinator?.presenter.navigationBar.isTranslucent = false
        self.coordinator?.presenter.navigationBar.tintColor = .colorGrayGray07
        self.coordinator?.presenter.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.colorGrayGray07]
        self.coordinator?.presenter.navigationBar.backItem?.title = ""
        setNavigationTitle()
    }

    private func setNavigationTitle() {
        var title = "내 피드 "
        if myDataType == .scrapedFeed {
            title = "스크랩 피드 "
        } else if myDataType == .favoriteRestaurant {
            title = "찜한 식당 "
        }
        let titleLabel = UILabel()
        let attributedString = NSMutableAttributedString()
            .bold(string: title, fontColor: .colorGrayGray07, fontSize: 16)
            .bold(string: String(viewModel.feeds.count), fontColor: .colorMainGreen03, fontSize: 16)
        titleLabel.attributedText = attributedString
        titleLabel.sizeToFit()

        self.coordinator?.presenter.navigationBar.topItem?.titleView = titleLabel
    }
}

extension MyDataViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if myDataType == .myFeed || myDataType == .scrapedFeed {
            return viewModel.feeds.count
        } else {
            return viewModel.restaurants.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if myDataType == .myFeed || myDataType == .scrapedFeed {
            let cell: TwoFeedCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            //Todo: 좋아요 버튼 눌렀을 때에 로그인 팝업을 띄우기 위한 coordinator 전달인데 MyDataViewController은 이미 로그인 이후니까 쓸모 없는 parameter 전송
            cell.configure(viewModel.feeds[indexPath.row], self.coordinator)
            return cell
        } else {
            let cell: OneFeedCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.configure(viewModel.restaurants[indexPath.row])
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if myDataType == .myFeed || myDataType == .scrapedFeed {
            return CGSize(width: CGFloat(164).widthRatio(), height: CGFloat(274))
        } else {
            return CGSize(width: CGFloat(375).widthRatio(), height: CGFloat(96))
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if myDataType == .myFeed || myDataType == .scrapedFeed {
            coordinator?.pushToFeedDetail(feedID: viewModel.feeds[indexPath.row].id)
        } else {

        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if myDataType == .myFeed || myDataType == .scrapedFeed {
            return CGFloat(20)
        } else {
            return .zero
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if myDataType == .myFeed || myDataType == .scrapedFeed {
            return CGFloat(15).widthRatio()
        } else {
            return .zero
        }
    }
}
