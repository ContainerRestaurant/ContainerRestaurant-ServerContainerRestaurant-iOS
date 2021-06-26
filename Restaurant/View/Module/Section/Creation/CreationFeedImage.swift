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
    var imageSubject: PublishSubject<UIImage>?

    @IBOutlet weak var imagePickerButton: UIButton!
    @IBOutlet weak var hideImageButton: UIButton!
    @IBOutlet weak var pickedImageView: UIImageView!
    @IBOutlet weak var registerButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()

        imagePicker.delegate = self
        bindingView()
    }

    func configure(_ coordinator: CreationFeedCoordinator, _ registerSubject: PublishSubject<Bool>, _ imageSubject: PublishSubject<UIImage>) {
        self.coordinator = coordinator
        self.registerSubject = registerSubject
        self.imageSubject = imageSubject
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

        registerButton.rx.tap
            .subscribe(onNext: { [weak self] in
                if let image = self?.image {
                    self?.imageSubject?.onNext(image)
                }
                print("등록버튼")
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
