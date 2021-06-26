//
//  SearchRestaurantViewController.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/06/01.
//

import UIKit
import RxSwift
import Alamofire

class SearchRestaurantViewController: BaseViewController, Storyboard, ViewModelBindableType {
    var viewModel: SearchRestaurantViewModel!
    weak var coordinator: SearchRestaurantCoordinator?
    var searchLocalSubject: PublishSubject<LocalSearch> = PublishSubject<LocalSearch>()
    var items: [LocalSearchItem]?

    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var searchRestaurantTextField: UITextField!
    @IBOutlet weak var textClearButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        setCollectionView()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    func bindingView() {
        closeButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.dismiss(animated: true, completion: nil)
            })
            .disposed(by: disposeBag)

        searchRestaurantTextField.rx.text
            .subscribe(onNext: { [weak self] in
                if let subject = self?.searchLocalSubject {
                    API().localSearch(text: $0 ?? "", subject: subject)
                }
            })
            .disposed(by: disposeBag)

        textClearButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.searchRestaurantTextField.text = ""
                self?.items = []
                self?.collectionView.reloadData()
            })
            .disposed(by: disposeBag)

        searchLocalSubject
            .subscribe(onNext: { [weak self] in
                self?.items = $0.items
                self?.collectionView.reloadData()
            })
            .disposed(by: disposeBag)
    }

    deinit {
        print("SearchRestaurantViewController Deinit")
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
        return self.items?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: SearchRestaurantCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        if let item = items?[indexPath.row] { cell.configure(item: item) }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let item = items?[indexPath.row] {
            viewModel.restaurantSubject?.onNext(item)
            self.dismiss(animated: true, completion: nil)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: CGFloat(65))
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }
}
