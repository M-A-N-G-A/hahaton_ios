//
//  EditProfileViewController.swift
//  OpenMVP
//
//  Created by Ayur Arkhipov on 28.11.2021.
//

import UIKit
import RxSwift
import RxCocoa

final class EditProfileViewController: UIViewController {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var followersBtn: UIButton!
    
//    var viewModel: <# name view model #>!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        makeSubviewsLayout()
        setupBindings()
    }
    
}

// MARK: - Setup UI
private extension EditProfileViewController {
    func setupUI() {
        followersBtn.layer.backgroundColor = UIColor.systemBlue.cgColor
        followersBtn.layer.cornerRadius = 12
        followersBtn.setTitleColor(.white, for: .normal)
    }
    
    func makeSubviewsLayout() {
        
    }
}

// MARK: - Setup Bindings
private extension EditProfileViewController {
    func setupBindings() {
        
    }
}
