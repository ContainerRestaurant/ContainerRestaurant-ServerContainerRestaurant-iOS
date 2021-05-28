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

        coordinator?.presentCreationFeed()
    }

    deinit {
        print("CreationViewController")
    }
}
