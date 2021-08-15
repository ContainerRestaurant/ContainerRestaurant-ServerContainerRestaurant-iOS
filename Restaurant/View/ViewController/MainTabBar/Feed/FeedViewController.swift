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
    var isSelectedCategoryIndex: Int = 0
    let selectedCategorySubject: PublishSubject<String> = PublishSubject<String>()
    let reloadFlagSubject: PublishSubject<[FeedPreviewModel]> = PublishSubject<[FeedPreviewModel]>()
    
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var latestOrderButton: UIButton!
    @IBOutlet weak var orderOfManyLikeButton: UIButton!
    @IBOutlet weak var orderOfLowDifficultyButton: UIButton!
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
        feedCollectionView.reloadData()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

//        disposeBag = DisposeBag()
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
        
        self.feedCollectionView.delegate = self
        self.feedCollectionView.dataSource = self
        self.feedCollectionView.register(TwoFeedInLineCollectionView.self)
    }
}

//MARK: - CollectionView Protocol
extension FeedViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionView == categoryCollectionView ? viewModel.category.count : 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == categoryCollectionView {
            let cell: CategoryTabCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.configure(viewModel.category[indexPath.row].1, self.isSelectedCategoryIndex == indexPath.row)
            return cell
        } else {
            let cell: TwoFeedInLineCollectionView = collectionView.dequeueReusableCell(for: indexPath)
            if let coordinator = self.coordinator {
                cell.configureFeedCategoryFeed(viewModel.categoryFeeds, self.selectedCategorySubject, self.reloadFlagSubject, coordinator)
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == categoryCollectionView {
            self.isSelectedCategoryIndex = indexPath.row
            self.categoryCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            self.categoryCollectionView.reloadData()
            
            let cateogry = viewModel.category[indexPath.row].0
            self.selectedCategorySubject.onNext(cateogry)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == categoryCollectionView {
            let label = UILabel(frame: CGRect.zero)
            label.text = viewModel.category[indexPath.row].1
            label.sizeToFit()
            return CGSize(width: label.frame.width.widthRatio(), height: 36)
        } else {
            return viewModel.categoryFeedCollectionViewSize()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == categoryCollectionView {
            return CGFloat(14).widthRatio()
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
