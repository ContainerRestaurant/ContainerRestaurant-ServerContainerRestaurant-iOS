//
//  CommonPopupViewController.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/04/28.
//

import UIKit
import RxSwift

enum PopupButtonType {
    case creationFeed
    case reportFeed
    case deleteFeed
    case deleteComment
    case reportComment
    case confirmReportComment
    case confirmExit
    case logout
    case unregister
    case none
}

class CommonPopupViewController: BaseViewController, Storyboard {
    weak var coordinator: CommonPopupCoordinator?
    var isTwoButton: Bool = true
    var buttonType: PopupButtonType = .none
    var feedID: String?
    var commentID: Int?
    var reloadSubject: PublishSubject<Void>?
    
    @IBOutlet weak var backgroundButton: UIButton!
    @IBOutlet weak var popupTitleLabel: UILabel!
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var cancelView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var okButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        cancelView.isHidden = !isTwoButton
        switch buttonType {
        case .creationFeed:
            setButton(buttonType)
            creationFeedBindingView()
        case .reportFeed:
            setButton(buttonType)
            reportFeedBindingView()
        case .deleteFeed:
            setButton(buttonType)
            deleteFeedBindingView()
        case .deleteComment:
            setButton(buttonType)
            deleteCommentBindingView()
        case .reportComment:
            setButton(buttonType)
            reportCommentBindingView()
        case .confirmReportComment:
            setButton(buttonType)
            confirmReportCommentBindingView()
        case .confirmExit:
            setButton(buttonType)
            confirmExitBindingView()
        case .logout:
            setButton(buttonType)
            logoutBindingView()
        case .unregister:
            setButton(buttonType)
            unregisterBindingView()
        case .none: break
        }

        backgroundButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.dismiss(animated: false, completion: nil)
            })
            .disposed(by: disposeBag)
    }

    func creationFeedBindingView() {
        cancelButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.dismiss(animated: false, completion: nil)
            })
            .disposed(by: disposeBag)

        okButton.rx.tap
            .subscribe(onNext: { [weak self] in
                APIClient.checkLogin(loginToken: UserDataManager.sharedInstance.loginToken) { [weak self] userModel in
                    if userModel.id == 0 {
                        self?.dismiss(animated: false, completion: nil)
                        self?.coordinator?.presentLogin()
                    } else {
                        self?.dismiss(animated: false, completion: nil)
                        self?.coordinator?.presenter.tabBarController?.selectedIndex = 2
                    }
                }
            })
            .disposed(by: disposeBag)
    }

    func reportFeedBindingView() {
        cancelButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.dismiss(animated: false, completion: nil)
            })
            .disposed(by: disposeBag)

        okButton.rx.tap
            .subscribe(onNext: { [weak self] in
                if let feedID = self?.feedID {
                    APIClient.reportFeed(feedID: feedID) { [weak self] isSuccess in
                        self?.dismiss(animated: false) { [weak self] in
                            self?.coordinator?.presentConfirmReportCommentPopup()
                        }
                    }
                }
            })
            .disposed(by: disposeBag)
    }

    func deleteFeedBindingView() {
        cancelButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.dismiss(animated: false, completion: nil)
            })
            .disposed(by: disposeBag)

        okButton.rx.tap
            .subscribe(onNext: { [weak self] in
                if let feedID = self?.feedID {
                    APIClient.deleteFeed(feedID: feedID) { [weak self] isSuccess in
                        self?.dismiss(animated: false) { [weak self] in
                            self?.coordinator?.presenter.popViewController(animated: true)
                            print(isSuccess ? "성공하면 컬렉션뷰 리로드" : "실패하면...얼럿?")
                        }
                    }
                }
            })
            .disposed(by: disposeBag)
    }

    func deleteCommentBindingView() {
        cancelButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.dismiss(animated: false, completion: nil)
            })
            .disposed(by: disposeBag)

        okButton.rx.tap
            .subscribe(onNext: { [weak self] in
                if let commentID = self?.commentID {
                    APIClient.deleteFeedComment(commentID: commentID) { [weak self] isSuccess in
                        self?.dismiss(animated: false) { [weak self] in
                            self?.reloadSubject?.onNext(())
                        }
                    }
                }
            })
            .disposed(by: disposeBag)
    }

    func reportCommentBindingView() {
        cancelButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.dismiss(animated: false, completion: nil)
            })
            .disposed(by: disposeBag)

        okButton.rx.tap
            .subscribe(onNext: { [weak self] in
                if let commentID = self?.commentID {
                    APIClient.reportComment(commentID: commentID) { [weak self] isSuccess in
                        self?.dismiss(animated: false) { [weak self] in
                            self?.coordinator?.presentConfirmReportCommentPopup()
                        }
//                        self?.dismiss(animated: false) { [weak self] in
//                            self?.reloadSubject?.onNext(())
//                        }
                    }
                }
            })
            .disposed(by: disposeBag)
    }

    func confirmReportCommentBindingView() {
        okButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.dismiss(animated: false, completion: nil)
            })
            .disposed(by: disposeBag)
    }

    func confirmExitBindingView() {
        cancelButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.dismiss(animated: false, completion: nil)
            })
            .disposed(by: disposeBag)

        okButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.dismiss(animated: false) {
                    Common.currentViewController()?.dismiss(animated: true, completion: nil)
                }
            })
            .disposed(by: disposeBag)
    }

    func logoutBindingView() {
        cancelButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.dismiss(animated: false) { [weak self] in
                    UserDataManager.sharedInstance.userID = 0
                    UserDataManager.sharedInstance.loginToken = ""
                    
                    self?.coordinator?.presenter.popViewController(animated: false)
                    self?.coordinator?.presenter.tabBarController?.selectedIndex = 0
                }
            })
            .disposed(by: disposeBag)

        okButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.dismiss(animated: false, completion: nil)
            })
            .disposed(by: disposeBag)
    }

    func unregisterBindingView() {
        cancelButton.rx.tap
            .subscribe(onNext: { [weak self] in
                APIClient.unregisterUser(userID: UserDataManager.sharedInstance.userID) { [weak self] isSuccess in
                    UserDataManager.sharedInstance.userID = 0
                    UserDataManager.sharedInstance.loginToken = ""

                    self?.dismiss(animated: false, completion: nil)
                    self?.coordinator?.presenter.popViewController(animated: false)
                    self?.coordinator?.presenter.tabBarController?.selectedIndex = 0
                }
            })
            .disposed(by: disposeBag)

        okButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.dismiss(animated: false, completion: nil)
            })
            .disposed(by: disposeBag)
    }

    private func setButton(_ buttonType: PopupButtonType) {
        switch buttonType {
        case .creationFeed:
            popupTitleLabel.text = "용기낸 경험을 들려주시겠어요?"
            cancelButton.setTitle("나중에요", for: .normal)
            okButton.setTitle("네, 좋아요!", for: .normal)
        case .deleteFeed, .deleteComment:
            popupTitleLabel.text = "정말 삭제하시겠습니까?"
            cancelButton.setTitle("취소", for: .normal)
            okButton.setTitle("삭제", for: .normal)
        case .reportComment, .reportFeed:
            popupTitleLabel.text = "정말 신고하시겠습니까?"
            cancelButton.setTitle("취소", for: .normal)
            okButton.setTitle("신고", for: .normal)
        case .confirmReportComment:
            let attributedString = NSMutableAttributedString()
                .bold(string: "신고가 접수되었어요!\n", fontColor: .colorGrayGray07, fontSize: 16)
                .bold(string: "빠른 시일 내에 조치하도록 할게요.", fontColor: .colorGrayGray07, fontSize: 16)

            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            paragraphStyle.paragraphSpacing = 4
            attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedString.length))

            popupTitleLabel.attributedText = attributedString
            okButton.setTitle("확인", for: .normal)
        case .confirmExit:
            let attributedString = NSMutableAttributedString()
                .bold(string: "작성을 종료할까요?\n", fontColor: .colorGrayGray07, fontSize: 16)
                .regular(string: "지금까지 작성한 내용은 저장되지 않아요.", fontColor: .colorGrayGray06, fontSize: 14)

            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            paragraphStyle.paragraphSpacing = 4
            attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedString.length))

            popupTitleLabel.attributedText = attributedString
            cancelButton.setTitle("취소", for: .normal)
            okButton.setTitle("확인", for: .normal)
        case .logout:
            popupTitleLabel.text = "정말 로그아웃 하시겠어요?"
            cancelButton.setTitle("로그아웃", for: .normal)
            okButton.setTitle("취소", for: .normal)
        case .unregister:
            let attributedString = NSMutableAttributedString()
                .bold(string: "계정 탈퇴 시 다시 되돌릴 수 없습니다.\n", fontColor: .colorGrayGray07, fontSize: 16)
                .bold(string: "정말 탈퇴 하시겠어요?", fontColor: .colorGrayGray07, fontSize: 16)

            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            paragraphStyle.paragraphSpacing = 4
            attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedString.length))

            popupTitleLabel.attributedText = attributedString
            cancelButton.setTitle("계정 탈퇴", for: .normal)
            okButton.setTitle("취소", for: .normal)
        case .none: break
        }
    }

    deinit {
        print("CreationPopupViewController Deinit")
    }
}
