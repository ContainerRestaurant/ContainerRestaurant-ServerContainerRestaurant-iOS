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
    var isReplyCommentSubject = PublishSubject<Int>()

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var commentBackgroundView: UIView!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var commentRegisterButton: UIButton!
    @IBOutlet weak var commentBackgroundBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var commentTextViewHeight: NSLayoutConstraint!

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
    }
    
    deinit {
        print("FeedDetailViewController Deinit")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setNavigation()

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(noti:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear(noti:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    func bindingView() {
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

        isReplyCommentSubject
            .subscribe(onNext: { [weak self] upperCommentID in
                self?.isReplyCommentState = true
                self?.upperCommentID = upperCommentID
                self?.commentTextView.becomeFirstResponder()
            })
            .disposed(by: disposeBag)

        commentRegisterButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let `self` = self else { return }
                guard let viewModel = self.viewModel else { return }
                guard let comment = self.commentTextView.text else { return }

                if self.isReplyCommentState {
                    APIClient.createFeedReplyComment(feedID: viewModel.feedID, content: comment, upperReplyID: self.upperCommentID) { [weak self] model in
                        self?.commentTextView.text = "댓글을 남겨주세요."
                        self?.commentTextView.textColor = .colorGrayGray05
                        self?.commentRegisterButton.setTitleColor(.colorGrayGray05, for: .normal)
                        self?.commentRegisterButton.isEnabled = false
                        self?.view.endEditing(true)

                        self?.viewModel.fetchCommentsOfFeed() { [weak self] in
                            let lastRowInCollectionView = (self?.viewModel.modules.count)!-1
                            self?.collectionView.reloadItems(at: [IndexPath(row: lastRowInCollectionView, section: 0)])
                        }

                        let collectionViewItemCount = self?.collectionView.numberOfItems(inSection: 0) ?? 1
                        self?.collectionView.scrollToItem(at: IndexPath.init(row: collectionViewItemCount-1, section: 0), at: .top, animated: true)
                    }
                } else {
                    APIClient.createFeedComment(feedID: viewModel.feedID, content: comment) { [weak self] _ in
                        self?.commentTextView.text = "댓글을 남겨주세요."
                        self?.commentTextView.textColor = .colorGrayGray05
                        self?.commentRegisterButton.setTitleColor(.colorGrayGray05, for: .normal)
                        self?.commentRegisterButton.isEnabled = false
                        self?.view.endEditing(true)
//                        self?.viewModel.comments.append($0)
//                        let lastRowInCollectionView = (self?.viewModel.modules.count)!-1
//                        self?.collectionView.reloadItems(at: [IndexPath(row: lastRowInCollectionView, section: 0)])
                        //아래껄로 되는지 확인해보기
                        self?.viewModel.fetchCommentsOfFeed() { [weak self] in
                            let lastRowInCollectionView = (self?.viewModel.modules.count)!-1
                            self?.collectionView.reloadItems(at: [IndexPath(row: lastRowInCollectionView, section: 0)])
                        }

                        let collectionViewItemCount = self?.collectionView.numberOfItems(inSection: 0) ?? 1
                        self?.collectionView.scrollToItem(at: IndexPath.init(row: collectionViewItemCount-1, section: 0), at: .top, animated: true)
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
    }
    
    private func setNavigation() {
        let backImage = UIImage(named: "chevronLeftOutline20Px")
        self.coordinator?.presenter.navigationBar.backIndicatorImage = backImage
        self.coordinator?.presenter.navigationBar.backIndicatorTransitionMaskImage = backImage
        
        self.coordinator?.presenter.navigationBar.barTintColor = .white
        self.coordinator?.presenter.navigationBar.tintColor = .colorGrayGray08
        self.coordinator?.presenter.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.colorGrayGray08]
        self.coordinator?.presenter.navigationBar.isTranslucent = false
        self.coordinator?.presenter.navigationBar.topItem?.title = ""

        let moreButton = UIButton(type: .custom)
        moreButton.setImage(UIImage(named: "moreHorizontalOutline20px"), for: .normal)
        moreButton.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        moreButton.addTarget(self, action: #selector(presentMoreMenu), for: .touchUpInside)
        let helpRightBarButtonItem = UIBarButtonItem(customView: moreButton)
//        self.coordinator?.presenter.navigationItem.rightBarButtonItem = helpRightBarButtonItem //Todo: 네비게이션 구조 파악하는데에 참고 해도 좋을듯 (얘는 안나오고 아래는 나옴)
        self.navigationItem.rightBarButtonItem = helpRightBarButtonItem
    }

    @objc func presentMoreMenu() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: "수정하기", style: .default , handler:{ (UIAlertAction) in
            print("User click Edit button")
        }))

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
}

//MARK: - Comment View
extension FeedDetailViewController: UITextViewDelegate {
    @objc func keyboardWillAppear(noti: NSNotification) {
        if let keyboardFrame: NSValue = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            var keyboardHeight = keyboardRectangle.height
            if UIDevice.current.hasNotch { keyboardHeight -= self.view.safeAreaInsets.bottom }

            if isFirstTapCommentView {
                self.commentBackgroundView.frame.origin.y -= keyboardHeight
                commentBackgroundBottomConstraint.constant -= keyboardHeight
                isFirstTapCommentView = false
                print("키보드 올라올 때: \(self.commentBackgroundView.frame.origin.y)")
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

            self.commentBackgroundView.frame.origin.y += keyboardHeight
            commentBackgroundBottomConstraint.constant += keyboardHeight
            isFirstTapCommentView = true
            print("키보드 사라질 때: \(self.commentBackgroundView.frame.origin.y)")

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
            cell.configure(coordinator, viewModel.feedID, viewModel.thumbnailURLObservable, viewModel.userProfileImageObservable, viewModel.userNicknameDriver, viewModel.userLevelDriver, viewModel.likeCountDriver, viewModel.scrapCountDriver, viewModel.userLevel, viewModel.isLike, viewModel.isScrap)
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
            cell.configure(comments: viewModel.comments, isReplyCommentSubject: isReplyCommentSubject)
            return cell

        default: return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch viewModel.modules[indexPath.row] {
        case is TopSectionOnFeedDetail.Type: return CGSize(width: UIScreen.main.bounds.width, height: CGFloat(329))

        case is TapOnFeedDetail.Type: return CGSize(width: UIScreen.main.bounds.width, height: CGFloat(37))

        case is RestaurantInformationOnFeedDetail.Type: return CGSize(width: UIScreen.main.bounds.width, height: CGFloat(viewModel.isWelcome ? 132 : 100))

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
            var widthoutCommentHeight = CGFloat(0)
            var commentLabelHeight = CGFloat(0)
            var widthoutReplyCommentHeight = CGFloat(0)
            var replyCommentLabelHeight = CGFloat(0)
            var replyCommentSeparateHeight = CGFloat(0)

            for comment in viewModel.comments {
                widthoutCommentHeight += CGFloat(101)
                let commentHeight = Common.labelHeight(text: comment.content, font: .systemFont(ofSize: 12), width: CGFloat(301).widthRatio())
                commentLabelHeight += commentHeight == 0 ? 14 : commentHeight

                for (index, replyComment) in comment.replyComment.enumerated() {
                    if index > 0 { replyCommentSeparateHeight += CGFloat(18) }
                    widthoutReplyCommentHeight += CGFloat(86)
                    let replyCommentHeight = Common.labelHeight(text: replyComment.content, font: .systemFont(ofSize: 12), width: CGFloat(235).widthRatio())
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

            let cellHeight = commentTitleHeight + widthoutCommentHeight + commentLabelHeight + widthoutReplyCommentHeight + replyCommentLabelHeight + replyCommentSeparateHeight

            return CGSize(width: UIScreen.main.bounds.width, height: cellHeight)

        default: return .zero
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
            self.isReplyCommentState = false
        }
    }
}
