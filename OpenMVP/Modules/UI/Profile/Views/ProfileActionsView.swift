//
//  ProfileActionsView.swift
//  OpenMVP
//
//  Created by Ayur Arkhipov on 27.11.2021.
//

import UIKit

final class ProfileActionsView: UIStackView {
    
    lazy var followBtn: UIButton = {
        let btn = UIButton()
        btn.layer.cornerRadius = 4
        btn.layer.backgroundColor = UIColor.systemBlue.cgColor // TODO: design
        btn.setTitle(AppLocalizator.follow.localized, for: .normal)
        return btn
    }()
    
    lazy var messageBtn: UIButton = {
        let btn = UIButton()
        btn.layer.cornerRadius = 4
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.systemGray.cgColor// TODO: design
        btn.setTitle(AppLocalizator.message.localized, for: .normal)
        btn.setTitleColor(.systemBlue, for: .normal)
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setup UI
private extension ProfileActionsView {
    func setupUI() {
        axis = .horizontal
        spacing = 4
        alignment = .fill
        distribution = .fillEqually
        [
            followBtn,
            messageBtn
        ]
        .forEach { addArrangedSubview($0) }
    }
}
