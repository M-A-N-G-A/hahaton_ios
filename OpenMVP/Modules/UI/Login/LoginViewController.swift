//
//  LoginViewController.swift
//  OpenMVP
//
//  Created by Ayur Arkhipov on 28.11.2021.
//

import UIKit

import UIKit
import RxSwift
import RxCocoa
import RxKeyboard

final class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var actionsStack: UIStackView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var buttonsBottomConstraint: NSLayoutConstraint!
    
    var viewModel: LoginViewModel!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupBindings()
    }
    
}

// MARK: - Setup UI
private extension LoginViewController {
    func setupUI() {
        navigationController?.setNavigationBarHidden(true, animated: false)
        loginButton.layer.backgroundColor = UIColor.systemBlue.cgColor
        loginButton.layer.cornerRadius = 12
        loginButton.setTitleColor(.white, for: .normal)
    }
}

// MARK: - Setup Bindings
private extension LoginViewController {
    func setupBindings() {
        RxKeyboard.instance.visibleHeight
            .drive(keyboardBinder)
            .disposed(by: disposeBag)
        
        guard let viewModel = viewModel else { return }
        
        let input = LoginViewModel.Input(
            userNameText: loginTextField.rx.text.asDriver(),
            passwordText: passwordTextField.rx.text.asDriver(),
            loginTap: loginButton.rx.tap.asDriver(),
            cancelTap: cancelButton.rx.tap.asDriver()
        )
        
        let output = viewModel.transform(input: input)
        
        [
            output.userNameText.drive(),
            output.passwordText.drive(),
            output.success.drive(),
            output.loading.drive(),
            output.error.drive()
        ]
        .forEach { $0.disposed(by: disposeBag) }
    }
    
    var keyboardBinder: Binder<CGFloat> {
        Binder(self) { vc, height in
            UIView.animate(withDuration: 0.3) {
                vc.buttonsBottomConstraint.constant = height + 16
            }
        }
    }
}
