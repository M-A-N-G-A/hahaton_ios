//
//  HomeViewController.swift
//  OpenMVP
//
//  Created by Ayur Arkhipov on 27.11.2021.
//

import UIKit

final class HomeViewController: UIViewController {
    
    var viewModel: HomeViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        makeSubviewsLayout()
        setupBindings()
    }
    
}

// MARK: - Setup UI
private extension HomeViewController {
    func setupUI() {
        view.backgroundColor = .red
    }
    
    func makeSubviewsLayout() {
        
    }
}

// MARK: - Setup Bindings
private extension HomeViewController {
    func setupBindings() {
        
    }
}

// MARK: - TabBarControllerProtocol
extension HomeViewController: TabBarControllerProtocol {
    var tabBarTitle: String {
        "Home"
    }
    
    var tabBarIcon: UIImage? {
        UIImage(systemName: "house.circle.fill")
    }
    
    func setupTabBarSettings() {
        self.title = tabBarTitle
    }
}
