//
//  LoginNavigator.swift
//  OpenMVP
//
//  Created by Ayur Arkhipov on 28.11.2021.
//

import UIKit.UINavigationController

protocol LoginNavigatorProtocol {
    
}

final class LoginNavigator {
    let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
}

extension LoginNavigator: LoginNavigatorProtocol {
    
}
