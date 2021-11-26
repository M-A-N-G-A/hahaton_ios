//
//  ProfileNavigator.swift
//  OpenMVP
//
//  Created by Ayur Arkhipov on 27.11.2021.
//

import UIKit.UINavigationController

protocol ProfileNavigatorProtocol {
    
}

final class ProfileNavigator {
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
}

extension ProfileNavigator: ProfileNavigatorProtocol {
    
}
