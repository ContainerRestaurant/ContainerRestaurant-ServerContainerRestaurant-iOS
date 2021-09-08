//
//  CreationFeedImage.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/06/05.
//

import UIKit
import RxSwift
import Photos

class CreationFeedImage: UICollectionViewCell {
    let disposeBag = DisposeBag()
    var coordinator: CreationFeedCoordinator?
    let imagePicker = UIImagePickerController()
    var registerSubject: PublishSubject<Bool> = PublishSubject<Bool>()
    var image: UIImage?
    var imageSubject: PublishSubject<UIImage?>?
    var contentsTextSubject: PublishSubject<String>?

    @IBOutlet weak var imagePickerButton: UIButton!
    @IBOutlet weak var hideImageButton: UIButton!
    @IBOutlet weak var pickedImageView: UIImageView!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var contentsTextView: UITextView!
    @IBOutlet weak var notEnoughInformationWarningLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        imagePicker.delegate = self
        contentsTextView.delegate = self
        contentsTextView.textContainerInset = .init(top: 15, left: 16, bottom: 15, right: 16)
        bindingView()
    }

    func configure(_ coordinator: CreationFeedCoordinator, _ restaurant: LocalSearchItem, _ mainMenuAndContainer: [MenuAndContainerModel], _ registerSubject: PublishSubject<Bool>, _ imageSubject: PublishSubject<UIImage?>, _ contentsTextSubject: PublishSubject<String>) {
        self.coordinator = coordinator
        self.registerSubject = registerSubject
        self.imageSubject = imageSubject
        self.contentsTextSubject = contentsTextSubject

        setNotEnoughInformationView(restaurant, mainMenuAndContainer)
    }

    func setNotEnoughInformationView(_ restaurant: LocalSearchItem, _ mainMenuAndContainer: [MenuAndContainerModel]) {
        if restaurant.title.isEmpty {
            var isEmpty = false
            for menuAndContainer in mainMenuAndContainer {
                isEmpty = menuAndContainer.menuName.isEmpty || menuAndContainer.container.isEmpty
                if isEmpty {
                    break
                }
            }

            notEnoughInformationWarningLabel.text = isEmpty ? "식당 이름, 메인음식 정보를 입력해주세요" : "식당 이름을 입력해주세요"
            registerButton.isEnabled = false
            registerButton.backgroundColor = .colorGrayGray04
        } else {
            var isEmpty = false
            for menuAndContainer in mainMenuAndContainer {
                isEmpty = menuAndContainer.menuName.isEmpty || menuAndContainer.container.isEmpty
                if isEmpty {
                    break
                }
            }

            notEnoughInformationWarningLabel.text = isEmpty ? "메인음식 정보를 입력해주세요" : ""
            registerButton.isEnabled = !isEmpty
            registerButton.backgroundColor = isEmpty ? .colorGrayGray04 : .colorMainGreen03
        }
    }

    private func bindingView() {
        imagePickerButton.rx.tap
            .subscribe(onNext: {
                PHPhotoLibrary.requestAuthorization({ (status) in
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

        hideImageButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.hideImageButton.isHidden = true
                self?.pickedImageView.isHidden = true
                self?.pickedImageView.image = nil
                self?.image = nil
            })
            .disposed(by: disposeBag)

        contentsTextView.rx.text
            .subscribe(onNext: { [weak self] contentsText in
                if let text = contentsText {
                    self?.contentsTextSubject?.onNext(text)
                }
            })
            .disposed(by: disposeBag)

        registerButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.imageSubject?.onNext(self?.image)
                self?.registerSubject.onNext(true)
            })
            .disposed(by: disposeBag)
    }
    
    deinit {
        print("사진 등록하고 닫으면 메모리 계속 쌓임")
    }
}

extension CreationFeedImage: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.hideImageButton.isHidden = false
            self.pickedImageView.isHidden = false
            self.pickedImageView.image = image
            self.image = image
        }

        Common.currentViewController()?.dismiss(animated: true, completion: nil)
    }
}

extension CreationFeedImage: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.textViewSetupView()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if contentsTextView.text == "" {
            self.textViewSetupView()
        }
    }
    
    //???????????????????????????????????????????
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        //개행시 최초 응답자 제거
        if text == "\n" {
            contentsTextView.resignFirstResponder()
        }
        return true
    }
    
    func textViewSetupView() {
        let placeHolder = "용기 구성 팁 등 타인에게 용기를 줄 수 있는 소감을 적어 주세요 :)"
        
        if contentsTextView.text == placeHolder {
            contentsTextView.text = ""
            contentsTextView.textColor = .black
        } else if contentsTextView.text == "" {
            contentsTextView.text = placeHolder
            contentsTextView.textColor = .colorGrayGray05
        }
    }
}
