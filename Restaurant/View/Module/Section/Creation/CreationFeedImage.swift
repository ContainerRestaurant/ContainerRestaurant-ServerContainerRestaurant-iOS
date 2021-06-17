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

    @IBOutlet weak var imagePickerButton: UIButton!
    @IBOutlet weak var hideImageButton: UIButton!
    @IBOutlet weak var pickedImageView: UIImageView!
    @IBOutlet weak var registerButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()

        imagePicker.delegate = self
        bind()
    }

    func configure(_ coordinator: CreationFeedCoordinator) {
        self.coordinator = coordinator
    }

    private func bind() {
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
            hideImageButton.isHidden = false
            pickedImageView.isHidden = false
            pickedImageView.image = image
        }

        Common.currentViewController()?.dismiss(animated: true, completion: nil)
    }
}
