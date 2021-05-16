//
//  MyViewController.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/04/06.
//

import UIKit

class MyViewController: BaseViewController, Storyboard {
    weak var coordinator: MyCoordinator?
    private var modules: [UICollectionViewCell] = []
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("MyViewController viewDidLoad()")
        
        setNavigationController()
        setModule()
        setCollectionView()
    }

    //안될거임
    deinit {
        print("MyViewController Deinit")
    }
}

//MARK: Instance Method
extension MyViewController {
    private func setNavigationController() {
        let settingButton = UIButton(type: .custom)
        settingButton.setImage(UIImage(named: "settingOutline"), for: .normal)
        settingButton.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        
        let barButton = UIBarButtonItem(customView: settingButton)
        //버튼 액션 추가
        
        self.navigationItem.setRightBarButton(barButton, animated: true)
        self.navigationItem.title = "마이 페이지"
    }
    
    private func setModule() {
        self.modules.append(MyProfileSection())
        self.modules.append(SeparateLineCollectionViewCell())
        self.modules.append(MyContentsCollectionView())
    }
    
    private func setCollectionView() {
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        self.collectionView.register(MyProfileSection.self)
        self.collectionView.register(SeparateLineCollectionViewCell.self)
        self.collectionView.register(MyContentsCollectionView.self)
    }
}

//MARK: - CollectionView Protocol
extension MyViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return modules.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let type = modules[indexPath.row]
        
        switch type {
        case is SeparateLineCollectionViewCell:
            let cell: SeparateLineCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.configureCell(height: 12)
            return cell
            
        case is MyProfileSection:
            let cell: MyProfileSection = collectionView.dequeueReusableCell(for: indexPath)
            return cell
            
        case is MyContentsCollectionView:
            let cell: MyContentsCollectionView = collectionView.dequeueReusableCell(for: indexPath)
            return cell
            
        default: return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let type = modules[indexPath.row]
        
        switch type {
        case is MyProfileSection: return CGSize(width: 375, height: 124)
        case is SeparateLineCollectionViewCell: return CGSize(width: 375, height: 12)
        case is MyContentsCollectionView: return CGSize(width: 375, height: 56*3) // 3 => dummy contents count
        default: return CGSize(width: 0, height: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat.zero
    }
}
