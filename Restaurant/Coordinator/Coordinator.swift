//
//  Coordinator.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/05/15.
//

import UIKit

protocol CoordinatorFinishDelegate {
    func coordinatorDidFinish()
    func removeChildCoordinator(_ coordinator: Coordinator)
}

protocol Coordinator: AnyObject, CoordinatorFinishDelegate {
    var delegate: CoordinatorFinishDelegate? { get set }
    var presenter: UINavigationController { get set }
    var childCoordinators: [Coordinator] { get set }
    
    func start() //컨트롤러 생성, 화면 전환 및 종속성 주입의 역할
}

extension Coordinator {
    func start() { }
    
    func coordinatorDidFinish() {
        delegate?.removeChildCoordinator(self)
    }
    
    func removeChildCoordinator(_ coordinator: Coordinator) {
        for (index, child) in childCoordinators.enumerated() where coordinator === child {
            childCoordinators.remove(at: index)
            break
        }
    }
}

//protocol CoordinatorContext {
//    associatedtype T: Coordinator
//    var coordinator: T? { get set }
//}
