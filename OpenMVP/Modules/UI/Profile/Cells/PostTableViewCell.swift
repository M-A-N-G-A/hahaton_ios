//
//  PostTableViewCell.swift
//  OpenMVP
//
//  Created by Ayur Arkhipov on 28.11.2021.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture

final class PostTableViewCell: UITableViewCell {
    
    private lazy var containerView = UIView()
    
    private lazy var userProfileView = ProfileRowView()
    
    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        // TODO: design
        return label
    }()
    
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var actionsView = PostActionsView()
    
    private lazy var likesView: PostLikesView = {
        let likesView = PostLikesView()
//        likesView.isHidden = true
//        likesView.alpha = 0
        return likesView
    }()
    
    var disposeBag = DisposeBag()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
        makeSubviewsLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
}

// MARK: - Setup UI
private extension PostTableViewCell {
    func setupUI() {
        layer.masksToBounds = true
        contentView.addSubview(containerView)
        [
            userProfileView,
            messageLabel,
            profileImageView,
            actionsView,
            likesView
        ]
        .forEach { containerView.addSubview($0) }
    }
    
    func makeSubviewsLayout() {
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(UIScreen.main.bounds.width - HomeViewController.Constants.horizontalInsets)
        }
        userProfileView.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
        }
        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(userProfileView.snp.bottom).offset(8)
            make.left.right.equalToSuperview()
        }
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(messageLabel.snp.bottom).offset(4)
            make.left.right.equalToSuperview()
        }
        actionsView.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(16)
            make.left.right.equalToSuperview()
        }
        likesView.snp.makeConstraints { make in
            make.top.equalTo(actionsView.snp.bottom).offset(8)
            make.left.right.bottom.equalToSuperview()
        }
    }
}

// MARK: - Setup Bindings
extension PostTableViewCell {
    func configure(with factory: @escaping (PostTableViewCellViewModel.Input) -> PostTableViewCellViewModel) {
        let input = PostTableViewCellViewModel.Input(
            profileTap: userProfileView.imageView.rx.tapGesture().when(.recognized).mapToVoid().asDriverOnErrorJustComplete(),
            followTap: userProfileView.followBtn.rx.tap.asDriver(),
            likeTap: actionsView.likeBtn.rx.tap.asDriver(),
            messageTap: actionsView.messageBtn.rx.tap.asDriver(),
            shareTap: actionsView.shareBtn.rx.tap.asDriver(),
            bookmarkTap: actionsView.bookmarkBtn.rx.tap.asDriver()
        )
        
        let viewModel = factory(input)
        
        let output = viewModel.transform(input: input)
        
        [
            output.profile.image.drive(userProfileView.imageView.rx.image),
            output.profile.name.drive(userProfileView.nameLabel.rx.text),
            output.profile.time.drive(userProfileView.timeLabel.rx.text),
            
            output.message.drive(messageLabel.rx.text),
            output.image.drive(profileImageView.rx.image),
            output.bookmarked.drive(actionsView.bookmarkedBinder),
            
            output.likeUsers.drive(likesView.textBinder),
            
            output.profileTap.drive(),
            output.followTap.drive(),
            output.likeTap.drive(),
            output.messageTap.drive(),
            output.shareTap.drive(),
            output.bookmarkTap.drive(),
            
            output.profileState.drive(actionsView.userStateBinder),
            output.profileState.drive(userStateBinder),
        ]
        .forEach { $0.disposed(by: disposeBag) }
    }
}

// MARK: - Rx Binders
extension PostTableViewCell {
    var userStateBinder: Binder<ProfileViewModel.State> {
        Binder(self) { view, state in
            switch state {
            case .me:
                view.userProfileView.followBtn.isHidden = true
            case .other(_):
                view.userProfileView.followBtn.isHidden = false
            }
        }
    }
}
