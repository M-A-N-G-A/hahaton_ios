//
//  ViewController.swift
//  OpenMVP
//
//  Created by Ayur Arkhipov on 27.11.2021.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tabBarControllers: [(UIViewController & TabBarControllerProtocol)] = [
            HomeViewController(),
            ProfileViewController()
        ]
        tabBarControllers.forEach { // TODO: check if needed
            $0.setupTabBarSettings()
        }
        setViewControllers(tabBarControllers, animated: false)
        
        guard let tabBarItems = tabBar.items else { return }
        
        for (index, item) in tabBarItems.enumerated() {
            item.image = tabBarControllers[index].tabBarIcon
        }
    }
}

