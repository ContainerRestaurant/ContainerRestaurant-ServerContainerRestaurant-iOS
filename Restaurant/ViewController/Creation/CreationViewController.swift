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
}
