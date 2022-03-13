//
//  SettingViewController.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/08/09.
//

import UIKit

class SettingViewController: BaseViewController, Storyboard {
    weak var coordinator: SettingCoordinator?

    @IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setCollectionView()
        print("SettingViewController viewDidLoad()")
    }

    deinit {
        print("SettingViewController Deinit")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.setNavigation()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        self.navigationItem.title = ""
    }
}

extension SettingViewController {
    private func setNavigation() {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        let backImage = UIImage(named: "chevronLeftOutline20Px")
        self.coordinator?.presenter.navigationBar.backIndicatorImage = backImage
        self.coordinator?.presenter.navigationBar.backIndicatorTransitionMaskImage = backImage
        self.coordinator?.presenter.navigationBar.backItem?.title = ""
        self.coordinator?.presenter.navigationBar.isTranslucent = false
        self.coordinator?.presenter.navigationBar.tintColor = .colorGrayGray07
        self.coordinator?.presenter.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.colorGrayGray07]

        self.navigationItem.title = "설정"
    }

    private func setCollectionView() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self

        self.collectionView.register(SettingCollectionViewCell.self)
    }
}

extension SettingViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: SettingCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)

        switch indexPath.row {
//        case 0: cell.alertConfigure()
        case 0: cell.configure(title: "개인정보 취급방침")
        case 1: cell.configure(title: "서비스 이용약관")
        case 2: cell.configure(title: "로그아웃")
        case 3: cell.configure(title: "계정 탈퇴")
        case 4: cell.appVersionConfigure()
        default: break
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0: coordinator?.pushPrivacyPolicy()
        case 1: coordinator?.pushServiceAccessTerms()
        case 2: coordinator?.logoutPopup()
        case 3: coordinator?.unregisterPopup()
        case 4: self.moveAppStoreAfterVersionCheck()
        default: break
        }
    }

    private func moveAppStoreAfterVersionCheck() {
        APIClient.appVersion() { appVersionModel in
            if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
                if version < appVersionModel.latestVersion {
                    Common.openAppStore(appId: "1586529640")
                }
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }
}
