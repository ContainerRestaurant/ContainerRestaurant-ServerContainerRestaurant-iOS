//
//  RestaurantSummaryInformationViewController.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/07/27.
//

import UIKit
import Cosmos

class RestaurantSummaryInformationViewController: BaseViewController, Storyboard, ViewModelBindableType {
    var viewModel: RestaurantSummaryInformationViewModel!
    weak var coordinator: RestaurantSummaryInformationCoordinator?

    @IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        setCollectionView()
        bindingView()

        print("RestaurantSummaryInformationViewController viewDidLoad()")
    }

    func bindingView() {

    }
    
    deinit {
        print("RestaurantSummaryInformationViewController Deinit")
    }
}

extension RestaurantSummaryInformationViewController {
    private func setCollectionView() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self

        self.collectionView.register(WelcomeViewInRestaurantSummaryInfo.self)
        self.collectionView.register(RestaurantSummaryInformation.self)
        self.collectionView.register(MainImageInRestaurantSummaryInfo.self)
        self.collectionView.register(FeedInRestaurantSummaryInfo.self)
    }
}

extension RestaurantSummaryInformationViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let type = viewModel.modules[indexPath.row]

        switch type {
        case is WelcomeViewInRestaurantSummaryInfo.Type:
            let cell: WelcomeViewInRestaurantSummaryInfo = collectionView.dequeueReusableCell(for: indexPath)
            return cell
        case is RestaurantSummaryInformation.Type:
            let cell: RestaurantSummaryInformation = collectionView.dequeueReusableCell(for: indexPath)
            return cell
        case is MainImageInRestaurantSummaryInfo.Type:
            let cell: MainImageInRestaurantSummaryInfo = collectionView.dequeueReusableCell(for: indexPath)
            return cell
        case is FeedInRestaurantSummaryInfo.Type:
            let cell: FeedInRestaurantSummaryInfo = collectionView.dequeueReusableCell(for: indexPath)
            return cell
        default: return UICollectionViewCell()
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let type = viewModel.modules[indexPath.row]

        switch type {
        case is WelcomeViewInRestaurantSummaryInfo.Type:
            return CGSize(width: CGFloat(375).widthRatio(), height: 31)
        case is RestaurantSummaryInformation.Type:
            return CGSize(width: CGFloat(375).widthRatio(), height: 97)
        case is MainImageInRestaurantSummaryInfo.Type:
            return CGSize(width: CGFloat(375).widthRatio(), height: 209)
        case is FeedInRestaurantSummaryInfo.Type:
            return CGSize(width: CGFloat(375).widthRatio(), height: 74 + 272*4 + 20*3)
        default:
            return CGSize.zero
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
