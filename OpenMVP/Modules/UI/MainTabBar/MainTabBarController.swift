//
//  ViewController.swift
//  OpenMVP
//
//  Created by Ayur Arkhipov on 27.11.2021.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    private lazy var homeVC: UINavigationController = {
        let vc = HomeViewController()
        let navigationVC = UINavigationController(rootViewController: vc)
        vc.viewModel = HomeViewModel(navigator: HomeNavigator(navigationController: navigationVC))
        return navigationVC
    }()
    
    private lazy var makePostVC: UINavigationController = {
        let vc = MakePostViewController()
        let navigationVC = UINavigationController(rootViewController: vc)
        vc.viewModel = MakePostViewModel(navigator: MakePostNavigator(navigationController: navigationVC))
        return navigationVC
    }()
    
    private lazy var profileVC: UINavigationController = {
        let vc = ProfileViewController()
        let navigationVC = UINavigationController(rootViewController: vc)
        vc.viewModel = ProfileViewModel(navigator: ProfileNavigator(navigationController: navigationVC))
        return navigationVC
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tabBarControllers = [
            homeVC,
            makePostVC,
            profileVC
        ]
        tabBarControllers.forEach { // TODO: check if needed
            guard let tabBarController = $0.viewControllers.first as? TabBarControllerProtocol else {
                return
            }
            tabBarController.setupTabBarSettings()
        }
        setViewControllers(tabBarControllers, animated: false)
        
        guard let tabBarItems = tabBar.items else { return }
        
        for (index, item) in tabBarItems.enumerated() {
            guard let tabBarController = tabBarControllers[index].viewControllers.first as? TabBarControllerProtocol else {
                return
            }
            item.image = tabBarController.tabBarIcon
        }
    }
}

