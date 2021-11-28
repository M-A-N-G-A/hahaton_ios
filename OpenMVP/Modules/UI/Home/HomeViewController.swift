//
//  HomeViewController.swift
//  OpenMVP
//
//  Created by Ayur Arkhipov on 27.11.2021.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

typealias HomeDataSource = RxCollectionViewSectionedReloadDataSource<HomeCellSectionModel>

final class HomeViewController: UIViewController {
    
    enum Constants {
        static let insets = UIEdgeInsets(top: 16, left: 8, bottom: 0, right: 8)
        static let horizontalInsets: CGFloat = insets.left + insets.right
    }
    
    private lazy var collectionViewLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 15
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        return layout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.register(StockCell.self)
        collectionView.register(PostCell.self)
        
        collectionView.bounces = true
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    private lazy var dataSource: HomeDataSource = {
        HomeDataSource { dataSource, collectionView, indexPath, data in
            switch dataSource[indexPath.section] {
            case let .stockSection(items: stockItems):
                guard let cell = collectionView.dequeueReusableCell(StockCell.self, by: indexPath) else {
                    return StockCell()
                }
                if case let .stockSectionItem(stock) = data {
                    cell.viewModel = StockCellViewModel(model: stock)
                    cell.configure { input in
                        let vm = StockCellViewModel(model: stock)
                        return vm
                    }
                }
                return cell
            case let .postSection(items: postItems):
                guard let cell = collectionView.dequeueReusableCell(PostCell.self, by: indexPath) else {
                    return PostCell()
                }
                if case let .postSectionItem(post) = data {
                    cell.configure { input in
                        let vm = PostCellViewModel(model: post, bookmarked: false)
                        input.profileTap
                            .map { post }
                            .drive(self.cellProfileTapSubject)
                            .disposed(by: cell.disposeBag)
                        input.followTap
                            .map { post }
                            .drive(self.cellFollowTapSubject)
                            .disposed(by: cell.disposeBag)
                        input.likeTap
                            .map { post }
                            .drive(self.cellLikeTapSubject)
                            .disposed(by: cell.disposeBag)
                        input.messageTap
                            .map { post }
                            .drive(self.cellMessageTapSubject)
                            .disposed(by: cell.disposeBag)
                        input.shareTap
                            .map { post }
                            .drive(self.cellShareTapSubject)
                            .disposed(by: cell.disposeBag)
                        input.bookmarkTap
                            .map { post }
                            .drive(self.cellBookmarkTapSubject)
                            .disposed(by: cell.disposeBag)
                        return vm
                    }
                }
                return cell
            }
        }
    }()
    
    let cellProfileTapSubject = PublishSubject<Post>()
    let cellFollowTapSubject = PublishSubject<Post>()
    let cellLikeTapSubject = PublishSubject<Post>()
    let cellMessageTapSubject = PublishSubject<Post>()
    let cellShareTapSubject = PublishSubject<Post>()
    let cellBookmarkTapSubject = PublishSubject<Post>()
    
    var viewModel: HomeViewModel!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        makeSubviewsLayout()
        setupBindings()
    }
    
}

// MARK: - Setup UI
private extension HomeViewController {
    func setupUI() {
        view.backgroundColor = .white
        
        [
            collectionView
        ]
        .forEach { view.addSubview($0) }
    }
    
    func makeSubviewsLayout() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: - Setup Bindings
private extension HomeViewController {
    func setupBindings() {
        guard let viewModel = viewModel else { return }
        
        let selectIndex = collectionView.rx
            .itemSelected
            .asDriver()
        
//        let selectModel = collectionView.rx
//            .modelSelected(Post.self)
//            .asDriver()
        
        let input = HomeViewModel.Input(
            willAppear: rx.viewWillAppear.asDriver(),
            
            cellActions: HomeViewModel.Input.PostCellActions(
                profileTap: cellProfileTapSubject.asDriverOnErrorJustComplete(),
                followTap: cellFollowTapSubject.asDriverOnErrorJustComplete(),
                likeTap: cellLikeTapSubject.asDriverOnErrorJustComplete(),
                messageTap: cellMessageTapSubject.asDriverOnErrorJustComplete(),
                shareTap: cellShareTapSubject.asDriverOnErrorJustComplete(),
                bookmarkTap: cellBookmarkTapSubject.asDriverOnErrorJustComplete(),
                
                indexSelected: selectIndex
            )
        )
        
        let output = viewModel.transform(input: input)
        
        collectionView.rx.setDelegate(self).disposed(by: disposeBag)
        output.dataSource
            .drive(collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        [
            output.cellActions.profileTap.drive(),
            output.cellActions.followTap.drive(),
            output.cellActions.likeTap.drive(),
            output.cellActions.messageTap.drive(),
            output.cellActions.shareTap.drive(),
            output.cellActions.bookmarkTap.drive(),
            
            output.cellActions.indexSelected.drive()
        ]
        .forEach { $0.disposed(by: disposeBag) }
    }
}

// MARK: - TabBarControllerProtocol
extension HomeViewController: TabBarControllerProtocol {
    var tabBarTitle: String {
        "Home"
    }
    
    var tabBarIcon: UIImage? {
        UIImage(systemName: "house.circle.fill")
    }
    
    func setupTabBarSettings() {
        self.title = tabBarTitle
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        Constants.insets
    }
}
