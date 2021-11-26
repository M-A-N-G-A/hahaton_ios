//
//  TabBarControllerProtocol.swift
//  OpenMVP
//
//  Created by Ayur Arkhipov on 27.11.2021.
//

import UIKit.UIImage

protocol TabBarControllerProtocol {
    var tabBarTitle: String { get }
    var tabBarIcon: UIImage? { get }
    
    func setupTabBarSettings()
}
