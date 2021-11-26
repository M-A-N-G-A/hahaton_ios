//
//  PostLikesView.swift
//  OpenMVP
//
//  Created by Ayur Arkhipov on 27.11.2021.
//

import UIKit
import RxSwift
import RxCocoa

final class PostLikesView: UILabel {
        
    func setup(with users: [User]) {
        if let lastUser = users.last {
            text = AppLocalizator.likedByPersonAndOthers.localized(with: lastUser.name, users.count)
            return
        }
        text = AppLocalizator.likedByPersons.localized(with: users.count)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // TODO: font, color
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PostLikesView {
    var textBinder: Binder<[User]> {
        Binder(self) { view, users in
            view.setup(with: users)
        }
    }
}
