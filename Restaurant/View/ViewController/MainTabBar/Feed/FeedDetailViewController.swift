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
    var isMainMenu = true
    var isFirstTapCommentView = true

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var commentBackgroundView: UIView!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var commentRegisterButton: UIButton!
    @IBOutlet weak var commentBackgroundBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var commentTextViewHeight: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()

        commentTextView.delegate = self
        commentTextView.textContainerInset = .zero
        
        setCollectionView()

        if viewModel.content.isEmpty {
            selectedTapType = .information
            viewModel.setInformationModules()
        } else {
            selectedTapType = .content
            viewModel.setContentModules()
        }

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

        print("FeedDetailViewController viewDidLoad()")
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
        print("FeedDetail bindingView()")

        commentRegisterButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.view.endEditing(true)
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
    }
}

//MARK: - Comment View
extension FeedDetailViewController: UITextViewDelegate {
    @objc func keyboardWillAppear(noti: NSNotification){
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
        }
    }

    @objc func keyboardWillDisappear(noti: NSNotification){
        if let keyboardFrame: NSValue = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            var keyboardHeight = keyboardRectangle.height
            if UIDevice.current.hasNotch { keyboardHeight -= self.view.safeAreaInsets.bottom }

            self.commentBackgroundView.frame.origin.y += keyboardHeight
            commentBackgroundBottomConstraint.constant += keyboardHeight
            isFirstTapCommentView = true
            print("키보드 사라질 때: \(self.commentBackgroundView.frame.origin.y)")
        }
    }

    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: textView.frame.width, height: .infinity)
        let estimatedHeight = textView.sizeThatFits(size).height
        let thirdLineHeight = CGFloat(55) //대략적 세 줄 높이 (원래는 50.33333)

        if estimatedHeight > thirdLineHeight {
            commentTextView.isScrollEnabled = true
        } else {
            commentTextViewHeight.constant = estimatedHeight < 20 ? 20 : estimatedHeight
            commentTextView.isScrollEnabled = false
        }


        print("텍스트 쳐질 때: \(self.commentBackgroundView.frame.origin.y)")
        print("text view size: \(estimatedHeight)")
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
            cell.configure(viewModel.thumbnailURLObservable, viewModel.userProfileImageObservable, viewModel.userNicknameDriver, viewModel.userLevelDriver, viewModel.likeCountDriver, viewModel.scrapCountDriver, viewModel.userLevel)
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
            if isMainMenu {
                cell.mainMenuConfigure(menuAndContainers: viewModel.mainMenuAndContainers)
                isMainMenu = false
            } else if !isMainMenu && viewModel.sideMenuAndContainers.count > 0 {
                cell.sideMenuConfigure(menuAndContainers: viewModel.sideMenuAndContainers)
            }
            return cell

        case is ContentOnFeedDetail.Type:
            let cell: ContentOnFeedDetail = collectionView.dequeueReusableCell(for: indexPath)
            cell.configure(content: viewModel.content)
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
            let isTwoOrMoreMainMenu = isMainMenu && viewModel.mainMenuAndContainers.count > 1
            let isTwoOrMoreSideMenu = !isMainMenu && viewModel.sideMenuAndContainers.count > 1
            if isTwoOrMoreMainMenu {
                cellHeight += CGFloat(64 * (viewModel.mainMenuAndContainers.count - 1))
            } else if isTwoOrMoreSideMenu {
                cellHeight += CGFloat(64 * (viewModel.sideMenuAndContainers.count - 1))
            }
            return CGSize(width: UIScreen.main.bounds.width, height: cellHeight)

        case is ContentOnFeedDetail.Type:
            let labelHeight = Common.labelHeight(text: viewModel.content, font: .systemFont(ofSize: 14), width: CGFloat(343).widthRatio())
//            let labelHeight = Common.labelHeight(text: "신전떡볶이 용기낸 후기입니다😙 사장님이 다회용기를 환영하는 뱃지를 보고 바로 가서 담아왔습니다! 생각보다 어렵지 않고 환경을 지키는 것에 대해 동참한다는 게 뿌듯하네요 신전떡볶이 용기낸 후기입니다😙 사장님이 다회용기를 환영하는 뱃지를 보고 바로 가서 담아왔습니다! 생각보다 어렵지 않고 환경을 지키는 것에 대해 동참한다는 게 뿌듯하네요", font: .systemFont(ofSize: 14), width: CGFloat(343).widthRatio())
            let otherHeight = CGFloat(26+1)
            let cellHeight = labelHeight + otherHeight

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
        }
    }
}
