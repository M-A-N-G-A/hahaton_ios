//
//  ProfileViewController.swift
//  OpenMVP
//
//  Created by Ayur Arkhipov on 27.11.2021.
//

import UIKit
import RxSwift
import RxCocoa

final class ProfileViewController: UIViewController {
    
    private lazy var containerView = UIView()
    
    private lazy var summaryView = ProfileSummaryView()
    
    /// visible when not on your self profile -> Potentially change to other type of actions TODO
    private lazy var actionsView = ProfileActionsView()
    
    private lazy var additionsContainerView = UIView()
    
    private lazy var postsTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(PostTableViewCell.self)
        return tableView
    }()
    
    let cellProfileTapSubject = PublishSubject<Post>()
    let cellFollowTapSubject = PublishSubject<Post>()
    let cellLikeTapSubject = PublishSubject<Post>()
    let cellMessageTapSubject = PublishSubject<Post>()
    let cellShareTapSubject = PublishSubject<Post>()
    let cellBookmarkTapSubject = PublishSubject<Post>()
    
    private let disposeBag = DisposeBag()
    
    var viewModel: ProfileViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        makeSubviewsLayout()
        setupBindings()
    }
    
}

// MARK: - Setup UI
private extension ProfileViewController {
    func setupUI() {
        view.backgroundColor = .white
        [
            containerView,
            postsTableView
        ]
        .forEach { view.addSubview($0) }
        [
            summaryView,
            actionsView
        ]
        .forEach { containerView.addSubview($0) }
        
    }
    
    func makeSubviewsLayout() {
        containerView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.left.right.equalTo(view.safeAreaLayoutGuide).inset(8)
        }
        summaryView.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
        }
        actionsView.snp.makeConstraints { make in
            make.top.equalTo(summaryView.snp.bottom).offset(8)
            make.left.right.bottom.equalToSuperview()
        }
        postsTableView.snp.makeConstraints { make in
            make.top.equalTo(actionsView.snp.bottom).offset(8)
            make.left.right.bottom.equalToSuperview()
        }
    }
}

// MARK: - Setup Bindings
private extension ProfileViewController {
    func setupBindings() {
        guard let viewModel = viewModel else { return }
        
        let input = ProfileViewModel.Input(
            willAppear: rx.viewWillAppear.mapToVoid().asDriverOnErrorJustComplete(),
            
            actions: ProfileViewModel.Input.Actions(
                followTap: actionsView.followBtn.rx.tap.asDriverOnErrorJustComplete(),
                messageTap: actionsView.messageBtn.rx.tap.asDriverOnErrorJustComplete(),
                editProfileTap: actionsView.editBtn.rx.tap.asDriverOnErrorJustComplete()
            )
        )
        
        let output = viewModel.transform(input: input)
        
        postsTableView.rx.setDelegate(self).disposed(by: disposeBag)
        output.posts.asObservable()
            .bind(to: postsTableView.rx
                    .items(cellIdentifier: Utilities.classNameAsString(obj: PostTableViewCell.self),
                           cellType: PostTableViewCell.self)) { row, post, cell in
                cell.configure { input in
                    let vm = PostTableViewCellViewModel(model: post, bookmarked: false)
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
            .disposed(by: disposeBag)
        
        [
            output.name.drive(summaryView.nameLabel.rx.text),
            output.image.drive(summaryView.imageView.rx.image),
            output.description.drive(summaryView.descriptionLabel.rx.text),
            output.followers.drive(summaryView.followersBinder),
            output.accuracy.drive(summaryView.accuracyBinder),
            output.actions.followTap.drive(),
            output.actions.messageTap.drive(),
            output.actions.editProfileTap.drive(),
            
            output.stateForView.drive(stateBinder),
            output.stateForView.drive(actionsView.stateBinder)
        ]
        .forEach { $0.disposed(by: disposeBag) }
    }
}

// MARK: - Rx Binders
extension ProfileViewController {
    var stateBinder: Binder<ProfileViewModel.State> {
        Binder(self) { view, state in
            // TODO: change cells or smth
        }
    }
}

// MARK: - TabBarControllerProtocol
extension ProfileViewController: TabBarControllerProtocol {
    var tabBarTitle: String {
        "Profile"
    }
    
    var tabBarIcon: UIImage? {
        UIImage(systemName: "person.crop.circle.fill")
    }
    
    func setupTabBarSettings() {
        self.title = tabBarTitle
    }
}

// MARK: - UITableViewDelegate
extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}
