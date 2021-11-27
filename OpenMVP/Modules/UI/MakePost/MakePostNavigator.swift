//
//  MakePostNavigator.swift
//  OpenMVP
//
//  Created by Ayur Arkhipov on 27.11.2021.
//

import UIKit.UINavigationController

protocol MakePostNavigatorProtocol {
    func importImage(result: @escaping ((Result<UIImage, Error>) -> Void))
}

final class MakePostNavigator {
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
}

extension MakePostNavigator: MakePostNavigatorProtocol {
    func importImage(result: @escaping ((Result<UIImage, Error>) -> Void)) {
        ImagePickerController.shared.pickImage(navigationController, result)
    }
}
