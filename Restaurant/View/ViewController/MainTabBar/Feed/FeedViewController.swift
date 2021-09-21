//
//  FeedViewController.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/04/06.
//

import UIKit
import RxSwift

class FeedViewController: BaseViewController, Storyboard, ViewModelBindableType {
    var viewModel: FeedViewModel!
    weak var coordinator: FeedCoordinator?
    var selectedCategoryIndex: Int = 0
    var selectedSortIndex: Int = 0
    let selectedCategoryAndSortSubject: PublishSubject<(String, Int)> = PublishSubject<(String, Int)>()
    let reloadFlagSubject: PublishSubject<[FeedPreviewModel]> = PublishSubject<[FeedPreviewModel]>()
    
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var sortCollectionView: UICollectionView!
    @IBOutlet weak var feedCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setCollectionViews()
        print("FeedViewController viewDidLoad()")
    }
    
    deinit {
        print("FeedViewController Deinit")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setNavigationBar()
        if UserDataManager.sharedInstance.isFirstEntryAfterLogin {
            APIClient.categoryFeed(category: "") { [weak self] categoryFeed in
                self?.viewModel.categoryFeeds = categoryFeed
                self?.feedCollectionView.reloadData()
            }
        }
    }

    func bindingView() {
        print("Search bindingView")
        
        self.reloadFlagSubject
            .subscribe(onNext: { [weak self] feeds in
                self?.viewModel.categoryFeeds = feeds
                self?.feedCollectionView.reloadData()
                self?.feedCollectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
            })
            .disposed(by: disposeBag)
    }
}

//MARK: - Instance Method
extension FeedViewController {
    private func setNavigationBar() {
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationItem.title = "피드 탐색"
        
        let attributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16)]
        UINavigationBar.appearance().titleTextAttributes = attributes
    }
    
    private func setCollectionViews() {
        self.categoryCollectionView.delegate = self
        self.categoryCollectionView.dataSource = self
        self.categoryCollectionView.register(CategoryTabCollectionViewCell.self)

        self.sortCollectionView.delegate = self
        self.sortCollectionView.dataSource = self
        self.sortCollectionView.register(SortButtonCollectionViewCell.self)
        
        self.feedCollectionView.delegate = self
        self.feedCollectionView.dataSource = self
        self.feedCollectionView.register(TwoFeedInLineCollectionView.self)
    }
}

//MARK: - CollectionView Protocol
extension FeedViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == categoryCollectionView {
            return viewModel.category.count
        } else if collectionView == sortCollectionView {
            return 4
        } else {
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == categoryCollectionView {
            let cell: CategoryTabCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.configure(viewModel.category[indexPath.row].1, self.selectedCategoryIndex == indexPath.row)
            return cell
        } else if collectionView == sortCollectionView {
            let cell: SortButtonCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            switch indexPath.row {
            case 0: cell.configure(self.selectedSortIndex == indexPath.row, "최신 순")
            case 1: cell.configure(self.selectedSortIndex == indexPath.row, "좋아요 많은 순")
            case 2: cell.configure(self.selectedSortIndex == indexPath.row, "난이도 낮은 순")
            case 3: cell.configure(self.selectedSortIndex == indexPath.row, "난이도 높은 순")
            default: break
            }
            return cell
        } else {
            let cell: TwoFeedInLineCollectionView = collectionView.dequeueReusableCell(for: indexPath)
            if let coordinator = self.coordinator {
                cell.configureFeedCategoryFeed(viewModel.categoryFeeds, self.selectedCategoryAndSortSubject, self.reloadFlagSubject, coordinator)
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == categoryCollectionView {
            self.selectedCategoryIndex = indexPath.row
            self.categoryCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            self.categoryCollectionView.reloadData()

            self.selectedSortIndex = 0
            self.sortCollectionView.reloadData()
            self.sortCollectionView.scrollToItem(at: [.zero], at: .centeredHorizontally, animated: true)

            let cateogry = viewModel.category[indexPath.row].0
            self.selectedCategoryAndSortSubject.onNext((cateogry, selectedSortIndex))
        } else if collectionView == sortCollectionView {
            self.selectedSortIndex = indexPath.row
            self.sortCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            self.sortCollectionView.reloadData()

            let cateogry = viewModel.category[indexPath.row].0
            self.selectedCategoryAndSortSubject.onNext((cateogry, selectedSortIndex))
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == categoryCollectionView {
            let label = PaddingLabel(frame: CGRect.zero)
            label.font = self.selectedCategoryIndex == indexPath.row ? .boldSystemFont(ofSize: 16) : .systemFont(ofSize: 16)
            label.paddingLeft = 10
            label.paddingRight = 10
            label.text = viewModel.category[indexPath.row].1
            label.sizeToFit()
            return CGSize(width: label.frame.width.widthRatio(), height: 47)
        } else if collectionView == sortCollectionView {
            let label = PaddingLabel(frame: .zero)
            label.font = self.selectedSortIndex == indexPath.row ? .boldSystemFont(ofSize: 14) : .systemFont(ofSize: 14)
            label.paddingLeft = 10
            label.paddingRight = 10
            switch indexPath.row {
            case 0: label.text = "최신 순"
            case 1: label.text = "좋아요 많은 순"
            case 2: label.text = "난이도 낮은 순"
            case 3: label.text = "난이도 높은 순"
            default: break
            }
            label.sizeToFit()
            return CGSize(width: label.frame.width.widthRatio(), height: 56)
        } else {
            return viewModel.categoryFeedCollectionViewSize()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == categoryCollectionView {
            return CGFloat(10).widthRatio()
        } else if collectionView == sortCollectionView {
            return CGFloat(4).widthRatio()
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
