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
    
    private lazy var additionsViewController = ProfileAdditionsViewController()
    
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
            additionsContainerView
        ]
        .forEach { view.addSubview($0) }
        [
            summaryView,
            actionsView
        ]
        .forEach { containerView.addSubview($0) }
        
        addChild(additionsViewController)
        additionsContainerView.addSubview(additionsViewController.view)
        additionsViewController.didMove(toParent: self)
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
        additionsContainerView.snp.makeConstraints { make in
            make.top.equalTo(containerView.snp.bottom).offset(8)
            make.left.right.bottom.equalToSuperview()
        }
        additionsViewController.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
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
                messageTap: actionsView.messageBtn.rx.tap.asDriverOnErrorJustComplete()
            )
        )
        
        let output = viewModel.transform(input: input)
        
        [
            output.name.drive(summaryView.nameLabel.rx.text),
            output.image.drive(summaryView.imageView.rx.image),
            output.description.drive(summaryView.descriptionLabel.rx.text),
            output.followers.drive(summaryView.followersBinder),
            output.accuracy.drive(summaryView.accuracyBinder),
            output.actions.followTap.drive(),
            output.actions.messageTap.drive()
        ]
        .forEach { $0.disposed(by: disposeBag) }
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
