//
//  PostActionsView.swift
//  OpenMVP
//
//  Created by Ayur Arkhipov on 27.11.2021.
//

import UIKit
import RxSwift
import RxCocoa

final class PostActionsView: UIView {
    
    private lazy var hStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 12
        stackView.alignment = .leading
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    lazy var likeBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "hand.thumbsup.fill")?.withRenderingMode(.alwaysTemplate), for: .normal)
        btn.imageView?.tintColor = UIColor.systemBlue // TODO: replace with design color
        return btn
    }()
    
    lazy var messageBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "message.fill")?.withRenderingMode(.alwaysTemplate), for: .normal)
        btn.imageView?.tintColor = UIColor.systemBlue // TODO: replace with design color
        return btn
    }()
    
    lazy var shareBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "square.and.arrow.up.fill")?.withRenderingMode(.alwaysTemplate), for: .normal)
        btn.imageView?.tintColor = UIColor.systemBlue // TODO: replace with design color
        return btn
    }()
    
    lazy var bookmarkBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "bookmark")?.withRenderingMode(.alwaysTemplate), for: .normal)
        btn.imageView?.tintColor = UIColor.systemBlue // TODO: replace with design color
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        makeSubviewsLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setup UI
private extension PostActionsView {
    func setupUI() {
        [
            likeBtn,
            messageBtn,
            shareBtn
        ]
        .forEach { hStackView.addArrangedSubview($0) }
        [
            hStackView,
            bookmarkBtn
        ]
        .forEach { addSubview($0) }
    }
    
    func makeSubviewsLayout() {
        hStackView.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
        }
        bookmarkBtn.snp.makeConstraints { make in
            make.top.right.bottom.equalToSuperview()
        }
    }
}

// MARK: - Rx
extension PostActionsView {
    var bookmarkedBinder: Binder<Bool> {
        Binder(self) { view, bookmarked in
            let image = UIImage(systemName: bookmarked ? "bookmark.fill" : "bookmark")
            view.bookmarkBtn.setImage(image?.withRenderingMode(.alwaysTemplate), for: .normal)
        }
    }
    
    var userStateBinder: Binder<ProfileViewModel.State> {
        Binder(self) { view, state in
            view.hStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
            switch state {
            case .me:
                [
                    view.shareBtn
                ]
                .forEach { view.hStackView.addArrangedSubview($0) }
            case .other(_):
                [
                    view.likeBtn,
                    view.messageBtn,
                    view.shareBtn
                ]
                .forEach { view.hStackView.addArrangedSubview($0) }
            }
        }
    }
}

