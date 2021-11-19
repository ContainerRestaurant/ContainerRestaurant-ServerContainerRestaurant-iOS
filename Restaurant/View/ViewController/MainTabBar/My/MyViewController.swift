//
//  MyViewController.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/04/06.
//

import UIKit
import RxSwift
import KakaoSDKUser
import Photos

class MyViewController: BaseViewController, Storyboard, ViewModelBindableType {
    weak var coordinator: MyCoordinator?
    var viewModel: MyViewModel!
    let imagePicker = UIImagePickerController()
    var isLoginSubject: PublishSubject<Bool> = PublishSubject<Bool>()
    let userDataSubject: PublishSubject<UserModel> = PublishSubject<UserModel>()
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileImageButton: UIButton!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var feedButton: UIButton!
    @IBOutlet weak var feedCountLabel: UILabel!
    @IBOutlet weak var scrapFeedButton: UIButton!
    @IBOutlet weak var scrapFeedCountLabel: UILabel!
    @IBOutlet weak var favoriteRestaurantButton: UIButton!
    @IBOutlet weak var favoriteRestaurantCountLabel: UILabel!
//    @IBOutlet weak var descriptionLevelButton: UIButton!
    @IBOutlet weak var settingButton: UIButton!
    @IBOutlet weak var nicknameUpdateButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        imagePicker.delegate = self
        print("MyViewController viewDidLoad()")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController?.setNavigationBarHidden(true, animated: true)

        let loginToken = UserDataManager.sharedInstance.loginToken
        APIClient.checkLogin(loginToken: loginToken) { [weak self] userModel in
            if userModel.id == 0 {
                self?.bindingView()
                self?.coordinator?.presentLogin()
            } else {
                self?.viewModel = MyViewModel(viewModel: userModel)
                self?.bindingViewAfterFetch()
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        disposeBag = DisposeBag()
    }

    func bindingView() {
        print("My bindingView")
        let defaultImage = Common.getDefaultProfileImage42("LV1. 텀블러")
        profileImageView.image = defaultImage
        nicknameLabel.text = "용기낸 식당"
        levelLabel.text = "Lv1. 텀블러"
        feedCountLabel.text = "0"
        scrapFeedCountLabel.text = "0"
        favoriteRestaurantCountLabel.text = "0"
    }
    
    func bindingViewAfterFetch() {
        print("My bindingViewAfterFetch")

        if viewModel.viewModel.profile.isEmpty {
            let defaultImage = Common.getDefaultProfileImage42(viewModel.viewModel.levelTitle)
            profileImageView.image = defaultImage
        } else {
            profileImageView.kf.setImage(with: URL(string: viewModel.viewModel.profile), options: [.transition(.fade(0.3))])
        }

        viewModel.nickname
            .drive(nicknameLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.levelTitle
            .drive(levelLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.feedCount
            .map { String($0) }
            .drive(feedCountLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.scrapFeedCount
            .map { String($0) }
            .drive(scrapFeedCountLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.bookmarkedCount
            .map { String($0) }
            .drive(favoriteRestaurantCountLabel.rx.text)
            .disposed(by: disposeBag)

        settingButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.coordinator?.pushSetting()
            })
            .disposed(by: disposeBag)

        profileImageButton.rx.tap
            .subscribe(onNext: { [weak self] in
                PHPhotoLibrary.requestAuthorization({ [weak self] (status) in
                    switch status {
                    case .authorized:
                        DispatchQueue.main.async { [weak self] in
                            guard let self = self else { return }

                            self.imagePicker.sourceType = .photoLibrary
                            Common.currentViewController()?.present(self.imagePicker, animated: true, completion: nil)
                        }
                    default:
                        DispatchQueue.main.async {
                            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                        }
                    }
                })
            })
            .disposed(by: disposeBag)

        feedButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.coordinator?.pushMyData(type: .myFeed)
            })
            .disposed(by: disposeBag)

        scrapFeedButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.coordinator?.pushMyData(type: .scrapedFeed)
            })
            .disposed(by: disposeBag)

        favoriteRestaurantButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.coordinator?.pushMyData(type: .favoriteRestaurant)
            })
            .disposed(by: disposeBag)

//        descriptionLevelButton.rx.tap
//            .subscribe(onNext: { [weak self] in
//                //계정 삭제
//                API().deleteUser()
//                //카카오 연결 끊기
////                UserApi.shared.unlink {(error) in
////                    if let error = error {
////                        print(error)
////                    }
////                    else {
////                        print("unlink() success.")
////                    }
////                }
//                self?.coordinator?.presenter.tabBarController?.selectedIndex = 0
//            })
//            .disposed(by: disposeBag)

        nicknameUpdateButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.coordinator?.pushNickNamePopup()
            })
            .disposed(by: disposeBag)
    }

    deinit {
        print("MyViewController Deinit")
    }
}

extension MyViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        //사용자 정보 업데이트...
        API().uploadImage(image: image) { [weak self] imageID in
            let userID = UserDataManager.sharedInstance.userID
            APIClient.updateUserProfile(userID: userID, profileID: imageID) { [weak self] userModel in
                self?.profileImageView.kf.setImage(with: URL(string: userModel.profile), options: [.transition(.fade(0.3))])
            }
        }

        Common.currentViewController()?.dismiss(animated: true, completion: nil)
    }
}
