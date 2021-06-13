//
//  CreationViewController.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/04/06.
//

import UIKit

class CreationViewController: BaseViewController, Storyboard {
    weak var coordinator: CreationCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("CreationViewController viewDidLoad()")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        //로그인 됐다면
//        coordinator?.presentCreationFeed()

        //로그인 안됐다면
        coordinator?.presentLogin()
    }

    deinit {
        print("CreationViewController")
    }
}
