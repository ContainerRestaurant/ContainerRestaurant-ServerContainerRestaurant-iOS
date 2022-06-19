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
    var disposeBag = DisposeBag()
    var coordinator: CreationFeedCoordinator?
    let imagePicker = UIImagePickerController()
    var registerSubject: PublishSubject<Bool> = PublishSubject<Bool>()
    var image: UIImage?
    var reuseImageSubject: PublishSubject<UIImage?>?
    var imageSubject: PublishSubject<UIImage?>?
    var contentsTextSubject: PublishSubject<String>?
    let placeHolder = "용기 구성 팁 등 타인에게 용기를 줄 수 있는 소감을 적어 주세요 :)"

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

    func configure(_ coordinator: CreationFeedCoordinator, _ viewModel: CreationFeedViewModel) {
        self.coordinator = coordinator
        self.registerSubject = viewModel.registerSubject
        self.reuseImageSubject = viewModel.reuseImageSubject
        self.imageSubject = viewModel.imageSubject
        self.contentsTextSubject = viewModel.contentsTextSubject

        if !viewModel.contentsText.isEmpty && viewModel.contentsText != placeHolder {
            contentsTextView.text = viewModel.contentsText
            contentsTextView.textColor = .black
        } else {
            contentsTextView.text = placeHolder
            contentsTextView.textColor = .colorGrayGray05
        }

        if let image = viewModel.reuseImage {
            pickedImageView.isHidden = false
            hideImageButton.isHidden = false
            pickedImageView.image = image
        }
        
        setNotEnoughInformationView(viewModel.restaurant ?? LocalSearchItem(), viewModel.mainMenuAndContainer)
    }

    private func setNotEnoughInformationView(_ restaurant: LocalSearchItem, _ mainMenuAndContainer: [MenuAndContainerModel]) {
        let isEvenOneEmpty = isEvenOneEmpty(mainMenuAndContainer)
        if restaurant.title.isEmpty {
            notEnoughInformationWarningLabel.text = isEvenOneEmpty ? "식당 이름, 메인음식 정보를 입력해주세요" : "식당 이름을 입력해주세요"
            registerButton.isEnabled = false
            registerButton.backgroundColor = .colorGrayGray04
        } else {
            notEnoughInformationWarningLabel.text = isEvenOneEmpty ? "메인음식 정보를 입력해주세요" : ""
            registerButton.isEnabled = !isEvenOneEmpty
            registerButton.backgroundColor = isEvenOneEmpty ? .colorGrayGray04 : .colorMainGreen03
        }
    }

    private func isEvenOneEmpty(_ mainMenuAndContainer: [MenuAndContainerModel]) -> Bool {
        for menuAndContainer in mainMenuAndContainer where menuAndContainer.menuName.isEmpty || menuAndContainer.container.isEmpty {
            return true
        }
        return false
    }

    private func bindingView() {
        imagePickerButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { (owner, _) in
                PHPhotoLibrary.requestAuthorization({ (status) in
                    switch status {
                    case .authorized:
                        DispatchQueue.main.async {
                            owner.imagePicker.sourceType = .photoLibrary
                            Common.currentViewController()?.present(owner.imagePicker, animated: true, completion: nil)
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
            .withUnretained(self)
            .subscribe(onNext: { (owner, _) in
                owner.hideImageButton.isHidden = true
                owner.pickedImageView.isHidden = true
                owner.pickedImageView.image = nil
                owner.reuseImageSubject?.onNext(nil)
                owner.image = nil
            })
            .disposed(by: disposeBag)

        contentsTextView.rx.text
            .withUnretained(self)
            .subscribe(onNext: { (owner, contentsText) in
                if let text = contentsText {
                    owner.contentsTextSubject?.onNext(text)
                }
            })
            .disposed(by: disposeBag)

        registerButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { (owner, _) in
                owner.imageSubject?.onNext(owner.image)
                owner.registerSubject.onNext(true)
            })
            .disposed(by: disposeBag)
    }
    
    deinit {
        print("CreationFeedImage Deinit & 사진 등록하고 닫으면 메모리 계속 쌓임")
    }
}

extension CreationFeedImage: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.hideImageButton.isHidden = false
            self.pickedImageView.isHidden = false
            self.pickedImageView.image = image
            self.reuseImageSubject?.onNext(image)
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
        self.textViewSetupView()
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
        if contentsTextView.text == placeHolder {
            contentsTextView.text = ""
            contentsTextView.textColor = .black
        } else if contentsTextView.text.isEmpty {
            contentsTextView.text = placeHolder
            contentsTextView.textColor = .colorGrayGray05
        }
    }
}
