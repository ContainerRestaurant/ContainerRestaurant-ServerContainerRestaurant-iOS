//
//  SearchRestaurantViewController.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/06/01.
//

import UIKit
import RxSwift
import RxCocoa
import Alamofire

class SearchRestaurantViewController: BaseViewController, Storyboard, ViewModelBindableType {
    var viewModel: SearchRestaurantViewModel!

    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var searchRestaurantTextField: UITextField!
    @IBOutlet weak var textClearButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        setCollectionView()
        print("SearchRestaurantViewController viewDidLoad()")
    }
    
    deinit {
        print("SearchRestaurantViewController Deinit")
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    func bindingView() {
        let input = SearchRestaurantViewModel.Input(textField: searchRestaurantTextField.rx.text,
                                                    closeTap: closeButton.rx.tap,
                                                    textClearTap: textClearButton.rx.tap)
        let output = viewModel.transform(input: input)

        output?.clearTextField
            .drive(searchRestaurantTextField.rx.text)
            .disposed(by: viewModel.disposeBag)

        output?.collectionViewReload
            .drive(onNext: { [weak self] in
                self?.collectionView.reloadData()
            })
            .disposed(by: viewModel.disposeBag)
    }
}

//MARK: - Instance Method
extension SearchRestaurantViewController {
    private func setCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self

        collectionView.register(SearchRestaurantCollectionViewCell.self)
    }
}

//MARK: - CollectionView Protocol
extension SearchRestaurantViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.items?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: SearchRestaurantCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        if let item = viewModel.items?[indexPath.row] {
            cell.configure(item: item)
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let item = viewModel.items?[indexPath.row] {
            viewModel.restaurantSubject?.onNext(item)
            dismiss(animated: true, completion: nil)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: CGFloat(65))
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }
}
