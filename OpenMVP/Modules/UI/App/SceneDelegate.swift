//
//  SceneDelegate.swift
//  OpenMVP
//
//  Created by Ayur Arkhipov on 27.11.2021.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        
        NotificationCenter.default.addObserver(self, selector:#selector(authorized(notification:)), name: LoginViewModel.NotificationAuthorized, object: nil)
        
        let vc: LoginViewController = LoginViewController.instantiate(appStoryboard: .auth)
        let navigationController = UINavigationController(rootViewController: vc)
        vc.viewModel = LoginViewModel(navigator: LoginNavigator(navigationController: navigationController))
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        self.window = window
    }
    
    @objc func authorized(notification: Notification) {
        self.window?.rootViewController = MainTabBarController()
    }
}
