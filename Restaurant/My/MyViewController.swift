//
//  MyViewController.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/04/06.
//

import UIKit

class MyViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setMyNavigationBar()
        setCollectionView()
    }
    
    func setMyNavigationBar() {
        self.navigationItem.title = "마이 페이지"
        
        let settingButton = UIButton(type: .custom)
        settingButton.setImage(UIImage(named: "settingOutline"), for: .normal)
        settingButton.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        let barButton = UIBarButtonItem(customView: settingButton)
        //버튼 액션
        
        self.navigationItem.setRightBarButton(barButton, animated: true)
    }
    
    func setCollectionView() {
        var nib = UINib(nibName: "MyProfileCollectionViewCell", bundle: nil)
        self.collectionView.register(nib, forCellWithReuseIdentifier: "MyProfileCollectionViewCell")
        nib = UINib(nibName: "SeparateLineCollectionViewCell", bundle: nil)
        self.collectionView.register(nib, forCellWithReuseIdentifier: "SeparateLineCollectionViewCell")
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
    }

    deinit {
        print("MyViewController Deinit")
    }
}

extension MyViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.row {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyProfileCollectionViewCell", for: indexPath)
            
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SeparateLineCollectionViewCell", for: indexPath) as! SeparateLineCollectionViewCell
            cell.configureCell(height: 12)
            
            return cell
        default: break
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 375, height: 124)
    }
}
