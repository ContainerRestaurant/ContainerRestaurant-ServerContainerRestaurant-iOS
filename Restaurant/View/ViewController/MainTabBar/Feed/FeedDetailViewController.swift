//
//  FeedDetailViewController.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/07/14.
//

import UIKit
import RxSwift

enum FeedDetailTap {
    case information
    case content
}

class FeedDetailViewController: BaseViewController, Storyboard, ViewModelBindableType {
    var viewModel: FeedDetailViewModel!
    weak var coordinator: FeedDetailCoordinator?
    var selectedTapTypeSubject = PublishSubject<FeedDetailTap>()
    var selectedTapType: FeedDetailTap = .information
    var isFirstTapCommentView = true
    var upperCommentID = 0
    var isReplyCommentState = false
    var isReplyCommentSubject = PublishSubject<CommentModel>()
    var isUpdateCommentState = false
    var updateCommentSubject = PublishSubject<CommentModel>()
    var selectedComment: CommentModel?
    var feedDetailViewWillAppearSubject: PublishSubject<Void>?
    var selectedCell: TwoFeedCollectionViewCell?
    var firstReachFlag = true

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var dimBackgroundView: UIView!
    @IBOutlet weak var dimView: UIView!
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var commentBackgroundView: UIView!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var commentTextViewHideButton: UIButton!
    @IBOutlet weak var commentRegisterButton: UIButton!
    @IBOutlet weak var commentBackgroundBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var commentTextViewHeight: NSLayoutConstraint!
    @IBOutlet weak var additionalCommentView: UIView!
    @IBOutlet weak var additionalCommentLabel: UILabel!
    @IBOutlet weak var additionalCommentViewCloseButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        setCollectionView()

        viewModel.fetchCommentsOfFeed() { [weak self] in
            let lastRowInCollectionView = (self?.viewModel.modules.count)!-1
            self?.collectionView.reloadItems(at: [IndexPath(row: lastRowInCollectionView, section: 0)])
        }

        commentTextView.delegate = self
        commentTextView.textContainerInset = .zero

        if viewModel.content.isEmpty {
            selectedTapType = .information
            viewModel.setInformationModules()
        } else {
            selectedTapType = .content
            viewModel.setContentModules()
        }

        self.separatorView.isHidden = true
        self.dimView.setVerticalGradient(startColor: .init(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.7), endColor: .init(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0))
    }
    
    deinit {
        print("FeedDetailViewController Deinit")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.coordinator?.presenter.navigationBar.isHidden = true
        self.coordinator?.presenter.navigationBar.barStyle = .black

        APIClient.checkLogin(loginToken: UserDataManager.sharedInstance.loginToken) { [weak self] userModel in
            self?.commentTextViewHideButton.isHidden = userModel.id != 0
        }

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(noti:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear(noti:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        self.coordinator?.presenter.navigationBar.barStyle = .default

        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        self.coordinator?.presenter.navigationBar.isHidden = coordinator?.isHiddenNavigationBarBeforePush ?? true
    }

    func bindingView() {
        feedDetailViewWillAppearSubject?
            .subscribe(onNext: { [weak self] in
                self?.viewWillAppear(true)
            })
            .disposed(by: disposeBag)

        selectedTapTypeSubject
            .subscribe(onNext: { [weak self] type in
                self?.selectedTapType = type

                switch type {
                case .information: self?.viewModel.setInformationModules()
                case .content: self?.viewModel.setContentModules()
                }

                self?.collectionView.reloadData()
            })
            .disposed(by: disposeBag)

        commentTextViewHideButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.coordinator?.presentLogin()
            })
            .disposed(by: disposeBag)

        updateCommentSubject
            .subscribe(onNext: { [weak self] comment in
                self?.selectedComment = comment
                self?.additionalCommentView.isHidden = false
                self?.isUpdateCommentState = true
                self?.commentTextView.becomeFirstResponder()
                self?.additionalCommentLabel.text = "내 댓글 수정중..."
                self?.commentTextView.text = comment.content
            })
            .disposed(by: disposeBag)

        isReplyCommentSubject
            .subscribe(onNext: { [weak self] comment in
                APIClient.checkLogin(loginToken: UserDataManager.sharedInstance.loginToken) { [weak self] userModel in
                    if userModel.id == 0 {
                        self?.coordinator?.presentLogin()
                    } else {
                        self?.additionalCommentView.isHidden = false
                        self?.isReplyCommentState = true
                        self?.upperCommentID = comment.id
                        self?.additionalCommentLabel.text = "[\(comment.userNickname)]님의 댓글에 대댓글 작성중..."
                        self?.commentTextView.becomeFirstResponder()
                    }
                }
            })
            .disposed(by: disposeBag)

        backButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.coordinator?.presenter.popViewController(animated: true)
            })
            .disposed(by: disposeBag)

        moreButton.rx.tap
            .subscribe(onNext: { [weak self] in
                let isMyFeed = self?.viewModel.userID == UserDataManager.sharedInstance.userID
                isMyFeed ? self?.presentMyMoreMenu() : self?.presentSomeoneElseMoreButton()
            })
            .disposed(by: disposeBag)

        additionalCommentViewCloseButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.commentTextView.text = ""
                self?.view.endEditing(true)
                self?.isReplyCommentState = false
                self?.isUpdateCommentState = false
                self?.additionalCommentView.isHidden = true
            })
            .disposed(by: disposeBag)

        commentRegisterButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let `self` = self else { return }
                guard let comment = self.commentTextView.text else { return }

                if self.isUpdateCommentState {
                    if let selectedComment = self.selectedComment {
                        self.updateFeedComment(comment: selectedComment, commentText: comment)
                    }
                } else {
                    if self.isReplyCommentState {
                        self.createFeedReplyComment(commentText: comment)
                    } else {
                        self.createFeedComment(commentText: comment)
                    }
                }
            })
            .disposed(by: disposeBag)
    }
}

//MARK: - Instance Method
extension FeedDetailViewController {
    private func setCollectionView() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self

        self.collectionView.register(TopSectionOnFeedDetail.self)
        self.collectionView.register(TapOnFeedDetail.self)
        self.collectionView.register(RestaurantInformationOnFeedDetail.self)
        self.collectionView.register(LevelOfDifficultyOnFeedDetail.self)
        self.collectionView.register(MenuOnFeedDetail.self)

        self.collectionView.register(ContentOnFeedDetail.self)

        self.collectionView.register(CommentSectionOnFeedDetail.self)
        self.collectionView.contentInsetAdjustmentBehavior = .never
    }

    private func presentMyMoreMenu() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

//        alert.addAction(UIAlertAction(title: "수정하기", style: .default , handler:{ (UIAlertAction) in
//            print("User click Edit button")
//        }))

        alert.addAction(UIAlertAction(title: "삭제하기", style: .destructive , handler:{ [weak self] (UIAlertAction) in
            if let feedID = self?.viewModel.feedID {
                self?.coordinator?.presentDeleteFeedPopup(feedID: feedID)
            }
        }))

        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler:{ (UIAlertAction) in
            print("User click Dismiss button")
        }))

        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }

    private func presentSomeoneElseMoreButton() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: "신고하기", style: .destructive , handler:{ [weak self] (UIAlertAction) in
            if let feedID = self?.viewModel.feedID {
                self?.coordinator?.presentReportFeedPopup(feedID: feedID)
            }
        }))

        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler:{ (UIAlertAction) in
            print("User click Dismiss button")
        }))

        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }

    private func updateFeedComment(comment: CommentModel, commentText: String) {
        APIClient.updateFeedComment(commentID: comment.id, content: commentText) { [weak self] model in
            self?.viewModel.fetchCommentsOfFeed() { [weak self] in
                let lastRowInCollectionView = (self?.viewModel.modules.count)!-1
                self?.collectionView.reloadItems(at: [IndexPath(row: lastRowInCollectionView, section: 0)])

                self?.commentTextView.text = ""
                self?.view.endEditing(true)
                self?.isReplyCommentState = false
                self?.isUpdateCommentState = false
                self?.additionalCommentView.isHidden = true
            }
        }
    }

    private func createFeedReplyComment(commentText: String) {
        APIClient.createFeedReplyComment(feedID: viewModel.feedID, content: commentText, upperReplyID: self.upperCommentID) { [weak self] model in
            self?.commentTextView.text = "댓글을 남겨주세요."
            self?.commentTextView.textColor = .colorGrayGray05
            self?.commentRegisterButton.setTitleColor(.colorGrayGray05, for: .normal)
            self?.commentRegisterButton.isEnabled = false
            self?.additionalCommentView.isHidden = true
            self?.isReplyCommentState = false
            self?.view.endEditing(true)

            self?.viewModel.fetchCommentsOfFeed() { [weak self] in
                let lastRowInCollectionView = (self?.viewModel.modules.count)!-1
                self?.collectionView.reloadItems(at: [IndexPath(row: lastRowInCollectionView, section: 0)])
            }
        }
    }

    private func createFeedComment(commentText: String) {
        APIClient.createFeedComment(feedID: viewModel.feedID, content: commentText) { [weak self] _ in
            self?.commentTextView.text = "댓글을 남겨주세요."
            self?.commentTextView.textColor = .colorGrayGray05
            self?.commentRegisterButton.setTitleColor(.colorGrayGray05, for: .normal)
            self?.commentRegisterButton.isEnabled = false
            self?.additionalCommentView.isHidden = true
            self?.view.endEditing(true)
            self?.viewModel.fetchCommentsOfFeed() { [weak self] in
                let lastRowInCollectionView = (self?.viewModel.modules.count)!-1
                self?.collectionView.reloadItems(at: [IndexPath(row: lastRowInCollectionView, section: 0)])

                let collectionViewItemCount = self?.collectionView.numberOfItems(inSection: 0) ?? 1
                self?.collectionView.scrollToItem(at: IndexPath.init(row: collectionViewItemCount-1, section: 0), at: .bottom, animated: true)
            }
        }
    }
}

//MARK: - Comment View
extension FeedDetailViewController: UITextViewDelegate {
    @objc func keyboardWillAppear(noti: NSNotification) {
        if let keyboardFrame: NSValue = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            var keyboardHeight = keyboardRectangle.height
            if UIDevice.current.hasNotch { keyboardHeight -= self.view.safeAreaInsets.bottom }

            if isFirstTapCommentView {
                self.view.frame.origin.y -= keyboardHeight
                isFirstTapCommentView = false
            }

            if self.commentTextView.text == "댓글을 남겨주세요." {
                self.commentTextView.text = ""
                self.commentTextView.textColor = .colorGrayGray07
            }
        }
    }

    @objc func keyboardWillDisappear(noti: NSNotification) {
        if let keyboardFrame: NSValue = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            var keyboardHeight = keyboardRectangle.height
            if UIDevice.current.hasNotch { keyboardHeight -= self.view.safeAreaInsets.bottom }

            self.view.frame.origin.y += keyboardHeight
            isFirstTapCommentView = true

            if self.commentTextView.text == "" {
                self.commentTextView.text = "댓글을 남겨주세요."
                self.commentTextView.textColor = .colorGrayGray05
            }
        }
    }

    func textViewDidChange(_ textView: UITextView) {
        commentRegisterButton.setTitleColor(textView.text.isEmpty ? .colorGrayGray05 : .colorMainGreen02, for: .normal)
        commentRegisterButton.isEnabled = !textView.text.isEmpty

        let size = CGSize(width: textView.frame.width, height: .infinity)
        let estimatedHeight = textView.sizeThatFits(size).height
        let thirdLineHeight = CGFloat(55) //대략적 세 줄 높이 (원래는 50.33333)

        if estimatedHeight > thirdLineHeight {
            commentTextView.isScrollEnabled = true
        } else {
            commentTextViewHeight.constant = estimatedHeight < 20 ? 20 : estimatedHeight
            commentTextView.isScrollEnabled = false
        }
    }
}

extension FeedDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.modules.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch viewModel.modules[indexPath.row] {
        case is TopSectionOnFeedDetail.Type:
            let cell: TopSectionOnFeedDetail = collectionView.dequeueReusableCell(for: indexPath)
            cell.configure(coordinator, viewModel, selectedCell: self.selectedCell!)
            return cell

        case is TapOnFeedDetail.Type:
            let cell: TapOnFeedDetail = collectionView.dequeueReusableCell(for: indexPath)
            cell.configure(viewModel.content, self.selectedTapType, self.selectedTapTypeSubject)
            return cell

        case is RestaurantInformationOnFeedDetail.Type:
            let cell: RestaurantInformationOnFeedDetail = collectionView.dequeueReusableCell(for: indexPath)
            cell.configure(category: viewModel.categoryDriver, restaurantName: viewModel.restaurantNameDriver, isWelcome: viewModel.isWelcomeDriver)
            return cell

        case is LevelOfDifficultyOnFeedDetail.Type:
            let cell: LevelOfDifficultyOnFeedDetail = collectionView.dequeueReusableCell(for: indexPath)
            cell.configure(levelOfDifficulty: viewModel.levelOfDifficulty)
            return cell

        case is MenuOnFeedDetail.Type:
            let cell: MenuOnFeedDetail = collectionView.dequeueReusableCell(for: indexPath)
            if indexPath.row == 4 {
                cell.mainMenuConfigure(menuAndContainers: viewModel.mainMenuAndContainers)
            } else {
                cell.sideMenuConfigure(menuAndContainers: viewModel.sideMenuAndContainers)
            }
            return cell

        case is ContentOnFeedDetail.Type:
            let cell: ContentOnFeedDetail = collectionView.dequeueReusableCell(for: indexPath)
            cell.configure(content: viewModel.content)
            return cell

        case is CommentSectionOnFeedDetail.Type:
            let cell: CommentSectionOnFeedDetail = collectionView.dequeueReusableCell(for: indexPath)
            cell.configure(coordinator: coordinator, comments: viewModel.comments, isReplyCommentSubject: isReplyCommentSubject, feedID: viewModel.feedID, updateCommentSubject: updateCommentSubject)
            return cell

        default: return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch viewModel.modules[indexPath.row] {

        case is TopSectionOnFeedDetail.Type:
            let imageSize: CGSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
            let topSectionHeightWithoutImage: CGFloat = 63
            return CGSize(width: imageSize.width, height: imageSize.height + topSectionHeightWithoutImage)

        case is TapOnFeedDetail.Type:
            return CGSize(width: UIScreen.main.bounds.width, height: CGFloat(37))

        case is RestaurantInformationOnFeedDetail.Type:
            return CGSize(width: UIScreen.main.bounds.width, height: CGFloat(viewModel.isWelcome ? 132 : 100))

        case is LevelOfDifficultyOnFeedDetail.Type:
            return CGSize(width: UIScreen.main.bounds.width, height: CGFloat(86))

        case is MenuOnFeedDetail.Type:
            var cellHeight = CGFloat(112)
            let isTwoOrMoreMainMenu = indexPath.row == 4 && viewModel.mainMenuAndContainers.count > 1
            let isTwoOrMoreSideMenu = indexPath.row == 5 && viewModel.sideMenuAndContainers.count > 1
            if isTwoOrMoreMainMenu {
                cellHeight += CGFloat(64 * (viewModel.mainMenuAndContainers.count - 1))
            } else if isTwoOrMoreSideMenu {
                cellHeight += CGFloat(64 * (viewModel.sideMenuAndContainers.count - 1))
            }
            return CGSize(width: UIScreen.main.bounds.width, height: cellHeight)

        case is ContentOnFeedDetail.Type:
            let labelHeight = Common.labelHeight(text: viewModel.content, font: .systemFont(ofSize: 14), width: CGFloat(343).widthRatio())
            return CGSize(width: UIScreen.main.bounds.width, height: labelHeight)

        case is CommentSectionOnFeedDetail.Type:
            let commentTitleHeight = CGFloat(76)
            var withoutCommentHeight = CGFloat(0)
            var commentLabelHeight = CGFloat(0)
            var withoutReplyCommentHeight = CGFloat(0)
            var replyCommentLabelHeight = CGFloat(0)
            var replyCommentSeparateHeight = CGFloat(0)

            for comment in viewModel.comments {
                if comment.isDeleted {
                    withoutCommentHeight += CGFloat(54)
                } else {
                    withoutCommentHeight += CGFloat(101)
                    let commentHeight = Common.labelHeight(text: comment.content, font: .systemFont(ofSize: 13), width: CGFloat(301).widthRatio())
                    commentLabelHeight += commentHeight == 0 ? 14 : commentHeight
                }

                for (index, replyComment) in comment.replyComment.enumerated() {
                    if index > 0 { replyCommentSeparateHeight += CGFloat(18) }
                    withoutReplyCommentHeight += CGFloat(86)
                    let replyCommentHeight = Common.labelHeight(text: replyComment.content, font: .systemFont(ofSize: 13), width: CGFloat(235).widthRatio())
                    replyCommentLabelHeight += replyCommentHeight == 0 ? 14 : replyCommentHeight
                }
            }

            if viewModel.comments.isEmpty {
                let emptyViewHeight = CGFloat(260)
                commentLabelHeight += emptyViewHeight
            } else {
                let lastCommentBottomSpacing = CGFloat(24)
                commentLabelHeight += lastCommentBottomSpacing
            }

            let cellHeight = commentTitleHeight + withoutCommentHeight + commentLabelHeight + withoutReplyCommentHeight + replyCommentLabelHeight + replyCommentSeparateHeight

            return CGSize(width: UIScreen.main.bounds.width, height: cellHeight)

        default:
            return .zero
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if scrollView == collectionView {
            self.view.endEditing(true)
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let isOverChangeLine = scrollView.contentOffset.y > UIScreen.main.bounds.width - self.dimBackgroundView.frame.height

        if isOverChangeLine && self.firstReachFlag {
            self.separatorView.isHidden = false
            self.dimView.isHidden = true
            self.firstReachFlag = false

            UIView.animate(withDuration: 0.2) { [weak self] in
                self?.dimBackgroundView.backgroundColor = .systemBackground
                self?.backButton.setImage(UIImage(named: "chevronLeftOutline20Px"), for: .normal)
                self?.moreButton.setImage(UIImage(named: "moreHorizontalOutline20px"), for: .normal)
                self?.coordinator?.presenter.navigationBar.barStyle = .default
            }
        } else if !isOverChangeLine && !self.firstReachFlag {
            self.separatorView.isHidden = true
            self.dimView.isHidden = false
            self.firstReachFlag = true

            UIView.animate(withDuration: 0.2) { [weak self] in
                self?.dimBackgroundView.backgroundColor = .clear
                self?.backButton.setImage(UIImage(named: "chevronLeftOutlineWhite20Px"), for: .normal)
                self?.moreButton.setImage(UIImage(named: "moreHorizontalOutlineWhite20px"), for: .normal)
                self?.coordinator?.presenter.navigationBar.barStyle = .black
            }
        }
    }
}
