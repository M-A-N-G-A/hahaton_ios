//
//  ProfileViewController.swift
//  OpenMVP
//
//  Created by Ayur Arkhipov on 27.11.2021.
//

import UIKit

final class ProfileViewController: UIViewController {
    
//    var viewModel: <# name #>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        makeSubviewsLayout()
        setupBindings()
    }
    
}

// MARK: - Setup UI
private extension ProfileViewController {
    func setupUI() {
        view.backgroundColor = .black
    }
    
    func makeSubviewsLayout() {
        
    }
}

// MARK: - Setup Bindings
private extension ProfileViewController {
    func setupBindings() {
        
    }
}

// MARK: - TabBarControllerProtocol
extension ProfileViewController: TabBarControllerProtocol {
    var tabBarTitle: String {
        "Profile"
    }
    
    var tabBarIcon: UIImage? {
        UIImage(systemName: "person.crop.circle.fill")
    }
    
    func setupTabBarSettings() {
        self.title = tabBarTitle
    }
}
