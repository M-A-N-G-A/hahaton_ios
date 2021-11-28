//
//  HomeNavigator.swift
//  OpenMVP
//
//  Created by Ayur Arkhipov on 27.11.2021.
//

import UIKit.UINavigationController

protocol HomeNavigatorProtocol {
    func pushPost(with post: Post)
}

final class HomeNavigator {
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
}

extension HomeNavigator: HomeNavigatorProtocol {
    func pushPost(with post: Post) {
        let vc: PostViewController = PostViewController.instantiate(appStoryboard: .post)
//        vc.setup(post)
        vc.post = post
        navigationController.pushViewController(vc, animated: true)
    }
}
