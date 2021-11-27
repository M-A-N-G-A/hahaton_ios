//
//  ProfileSummaryView.swift
//  OpenMVP
//
//  Created by Ayur Arkhipov on 27.11.2021.
//

import UIKit
import RxSwift
import RxCocoa

final class ProfileSummaryView: UIView {
    
    enum Constants {
        static let iconSize = CGSize(width: 64, height: 64)
    }
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIColor.systemBlue.image()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = Constants.iconSize.width / 2
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private lazy var hStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    lazy var followersLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        // TODO: add font, color
        return label
    }()
    
    lazy var accuracyLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        // TODO: add font, color
        return label
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        // TODO: add font, color
        return label
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        // TODO: add font, color
        return label
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
private extension ProfileSummaryView {
    func setupUI() {
        [
            followersLabel,
            accuracyLabel,
        ]
        .forEach { hStackView.addArrangedSubview($0) }
        [
            imageView,
            hStackView,
            nameLabel,
            descriptionLabel
        ]
        .forEach { addSubview($0) }
    }
    
    func makeSubviewsLayout() {
        imageView.snp.makeConstraints { make in
            make.left.top.equalToSuperview()
            make.size.equalTo(Constants.iconSize)
        }
        hStackView.snp.makeConstraints { make in
            make.left.equalTo(imageView.snp.right).offset(16)
            make.centerY.equalTo(imageView)
            make.right.equalToSuperview()
        }
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(8)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(16)
            make.left.right.bottom.equalToSuperview()
        }
    }
}

// MARK: - Rx
extension ProfileSummaryView {
    var followersBinder: Binder<Int?> {
        Binder(self) { view, followers in
            view.followersLabel.text = AppLocalizator.numFollowers.localized(with: followers ?? 0)
        }
    }
    
    var accuracyBinder: Binder<Float?> {
        Binder(self) { view, accuracy in
            guard let accuracy = accuracy else {
                view.accuracyLabel.text = AppLocalizator.naTradeAccuracy.localized
                return
            }
            view.accuracyLabel.text = AppLocalizator.numTradeAccuracy.localized(with: accuracy)
        }
    }
}
