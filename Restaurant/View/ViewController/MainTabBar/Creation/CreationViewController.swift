//
//  CreationViewController.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/04/06.
//

import UIKit
import RxSwift

class CreationViewController: BaseViewController, Storyboard {
    weak var coordinator: CreationCoordinator?
    var isLoginSubject: PublishSubject<Bool> = PublishSubject<Bool>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("CreationViewController viewDidLoad()")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //로그인 여부로 피드쓰기 띄울지 로그인 띄울지 결정
        //Todo: 피드 띄울때에 시간이 좀 걸림, 해결 필요
        APIClient.checkLogin(loginToken: UserDataManager.sharedInstance.loginToken) { [weak self] userModel in
            print("로그인 된건가요")
            print(userModel)
            print("로그인 된건가요")

            guard let coordinator = self?.coordinator else { return }
            userModel.id > 0 ? coordinator.presentCreationFeed() : coordinator.presentLogin()
        }
//        API().askUser(isLoginSubject: isLoginSubject)
//        self.isLoginSubject.subscribe(onNext: { [weak self] isLogin in
//            print("로그인 여부: \(isLogin)")
//            guard let coordinator = self?.coordinator else { return }
//            isLogin ? coordinator.presentCreationFeed() : coordinator.presentLogin()
//        })
//        .disposed(by: disposeBag)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        disposeBag = DisposeBag()
    }

    deinit {
        print("CreationViewController")
    }
}
