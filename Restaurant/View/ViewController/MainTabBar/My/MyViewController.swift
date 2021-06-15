//
//  MyViewController.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/04/06.
//

import UIKit
import RxSwift

class MyViewController: BaseViewController, Storyboard, ViewModelBindableType {
    weak var coordinator: MyCoordinator?
    var viewModel: MyViewModel!
    var isLoginSubject: PublishSubject<Bool> = PublishSubject<Bool>()
    let userDataSubject: PublishSubject<UserModel> = PublishSubject<UserModel>()
    
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var feedButton: UIButton!
    @IBOutlet weak var feedCountLabel: UILabel!
    @IBOutlet weak var scrapFeedButton: UIButton!
    @IBOutlet weak var scrapFeedCountLabel: UILabel!
    @IBOutlet weak var bookmarkedCountButton: UIButton!
    @IBOutlet weak var bookmarkedCountLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("MyViewController viewDidLoad()")
        
        feedButton.rx.tap
            .subscribe(onNext: {
                print("내 피드")
            })
            .disposed(by: disposeBag)
        
        scrapFeedButton.rx.tap
            .subscribe(onNext: {
                print("스크랩 피드")
            })
            .disposed(by: disposeBag)
        
        bookmarkedCountButton.rx.tap
            .subscribe(onNext: {
                print("찜한 식당")
            })
            .disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)

        API().askUser(isLoginSubject: isLoginSubject, userDataSubject: userDataSubject)
        Observable.zip(isLoginSubject, userDataSubject)
            .subscribe(onNext: { [weak self] (isLogin, userData) in
                if !isLogin { self?.coordinator?.presentLogin() }
                self?.viewModel = MyViewModel(viewModel: userData)
                
                self?.bindViewModel()
            })
            .disposed(by: disposeBag)
    }
    
    func bindViewModel() {
        print("My bindViewModel")
        
        viewModel.nickname
            .drive(nicknameLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.level
            .map { String($0) }
            .drive(levelLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.feedCount
            .map { String($0) }
            .drive(feedCountLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.scrapFeedCount
            .map { String($0) }
            .drive(scrapFeedCountLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.bookmarkedCount
            .map { String($0) }
            .drive(bookmarkedCountLabel.rx.text)
            .disposed(by: disposeBag)
    }

    deinit {
        print("MyViewController Deinit")
    }
}
