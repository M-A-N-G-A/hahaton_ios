//
//  ProfileRowView.swift
//  OpenMVP
//
//  Created by Ayur Arkhipov on 27.11.2021.
//

import UIKit

final class ProfileRowView: UIView {
    
    enum Constants {
        static let iconSize = CGSize(width: 48, height: 48)
    }
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = "placeholder".image()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = Constants.iconSize.width / 2
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private lazy var vStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4
        return stackView
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        // TODO: add font, color
        return label
    }()
    
    lazy var timeLabel: UILabel = {
        let label = UILabel()
        // TODO: add font, color
        return label
    }()
    
    lazy var followBtn: UIButton = {
        let btn = UIButton()
        // TODO: add font, color
        btn.setTitle(AppLocalizator.follow.localized, for: .normal)
        btn.setTitleColor(.systemBlue, for: .normal)
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
private extension ProfileRowView {
    func setupUI() {
        [
            nameLabel,
            timeLabel
        ]
        .forEach { vStackView.addArrangedSubview($0) }
        [
            imageView,
            vStackView,
            followBtn
        ]
        .forEach { addSubview($0) }
    }
    
    func makeSubviewsLayout() { // TODO: add insets if needed
        imageView.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview()
            make.size.equalTo(Constants.iconSize)
        }
        vStackView.snp.makeConstraints { make in
            make.left.equalTo(imageView.snp.right).offset(8)
            make.centerY.equalTo(imageView.snp.centerY)
        }
        followBtn.snp.makeConstraints { make in
            make.left.greaterThanOrEqualTo(vStackView.snp.right).offset(16)
            make.centerY.equalTo(imageView.snp.centerY)
            make.right.equalToSuperview()
        }
    }
}
