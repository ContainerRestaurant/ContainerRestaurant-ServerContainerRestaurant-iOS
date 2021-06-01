//
//  MyViewController.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/04/06.
//

import UIKit

class MyViewController: BaseViewController, Storyboard {
    weak var coordinator: MyCoordinator?
    
    @IBOutlet weak var myFeedButton: UIButton!
    @IBOutlet weak var scrapFeedButton: UIButton!
    @IBOutlet weak var zzimedRestaurantButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("MyViewController viewDidLoad()")
        
        myFeedButton.rx.tap
            .subscribe(onNext: {
                print("내 피드")
            })
            .disposed(by: disposeBag)
        
        scrapFeedButton.rx.tap
            .subscribe(onNext: {
                print("스크랩 피드")
            })
            .disposed(by: disposeBag)
        
        zzimedRestaurantButton.rx.tap
            .subscribe(onNext: {
                print("찜한 식당")
            })
            .disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }

    deinit {
        print("MyViewController Deinit")
    }
}
