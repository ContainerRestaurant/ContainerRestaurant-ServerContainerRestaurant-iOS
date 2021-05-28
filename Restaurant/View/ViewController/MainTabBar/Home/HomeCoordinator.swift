//
//  HomeCoordinator.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/05/15.
//

import UIKit
import RxSwift
import Alamofire

class HomeCoordinator: NSObject, Coordinator {
    var delegate: CoordinatorFinishDelegate?
    var presenter: UINavigationController
    var childCoordinators: [Coordinator]
    
    var viewModel: HomeViewModel?
    let recommendFeedSubject: PublishSubject<RecommendFeed> = PublishSubject<RecommendFeed>()
    let disposeBag = DisposeBag()
    
    init(presenter: UINavigationController) {
        self.presenter = presenter
        self.childCoordinators = []
    }
    
    func start() {
        API().recommendFeed(subject: self.recommendFeedSubject)

        let home = HomeViewController.instantiate()
        home.coordinator = self
        home.viewModel = HomeViewModel(viewModel: RecommendFeed(_embedded: Embedded(feedPreviewDtoList: [])))

        self.presenter.pushViewController(home, animated: false)
//        self.recommendFeedSubject.subscribe(onNext: { [weak self] in
//            let home = HomeViewController.instantiate()
//            home.coordinator = self
//            home.viewModel = HomeViewModel(viewModel: $0)
//
//            self?.presenter.pushViewController(home, animated: false)
//        })
//        .disposed(by: disposeBag)
    }
}

extension HomeCoordinator {
    func presentToMyContainer() {
        let coordinator = CreationPopupCoordinator(presenter: presenter)
        coordinator.delegate = self
        childCoordinators.append(coordinator)
        coordinator.start()
    }
    
    func pushToContainerOfEveryone() {
        let coordinator = ContainerOfEveryoneCoordinator(presenter: presenter)
        coordinator.delegate = self
        childCoordinators.append(coordinator)
        coordinator.start()
    }
}

//extension HomeCoordinator {
//    func getTest() {
//        let url = API.shared.url(type: .test)
//
//        AF.request(url).responseJSON { (response) in
//            switch response.result {
//            case .success(let obj):
//                do {
//                    let dataJSON = try JSONSerialization.data(withJSONObject: obj, options: .fragmentsAllowed)
//                    let getInstanceData = try JSONDecoder().decode(TestCodable.self, from: dataJSON)
//
//                    print(getInstanceData.drinks[0].idDrink)
//                } catch {
//                    print(error.localizedDescription)
//                }
//            case .failure(let e):
//                print(e.localizedDescription)
//            }
//
//        }
//    }
//
//    func getPost() {
//        let url = "https://ptsv2.com/t/w4cdg-1621528175/post"
//        var request = URLRequest(url: URL(string: url)!)
//        request.httpMethod = "POST"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.timeoutInterval = 10
//
//        // POST 로 보낼 정보
//        let params = ["id":"pos00042", "pw":"password00042"] as Dictionary
//
//        // httpBody 에 parameters 추가
//        do {
//            try request.httpBody = JSONSerialization.data(withJSONObject: params, options: [])
//        } catch {
//            print("http Body Error")
//        }
//
//        AF.request(request).responseString { (response) in
//            switch response.result {
//            case .success:
//                print("POST 성공")
//            case .failure(let error):
//                print("🚫 Alamofire Request Error\nCode:\(error._code), Message: \(error.errorDescription!)")
//            }
//        }
//    }
//}
