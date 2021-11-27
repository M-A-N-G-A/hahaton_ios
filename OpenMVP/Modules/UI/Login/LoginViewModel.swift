//
//  LoginViewModel.swift
//  OpenMVP
//
//  Created by Ayur Arkhipov on 28.11.2021.
//

import UIKit
import RxSwift
import RxCocoa

final class LoginViewModel: ViewModelType {
    struct Input {
        let userNameText: Driver<String?>
        let passwordText: Driver<String?>
        
        let loginTap: Driver<Void>
        let cancelTap: Driver<Void>
    }
    struct Output {
        let userNameText: Driver<String?>
        let passwordText: Driver<String?>
        let success: Driver<Void>
        let error: Driver<Error>
        let loading: Driver<Bool>
    }
    
    static let NotificationAuthorized = NSNotification.Name(rawValue: "Authorized")
    
    private let navigator: LoginNavigatorProtocol
    private let api: Api
    
    init(navigator: LoginNavigatorProtocol) {
        self.navigator = navigator
        self.api = Api()
    }
    
    var username: String?
    var password: String?
    
    func transform(input: Input) -> Output {
        let activityIndicator = ActivityIndicator()
        let errorTracker = ErrorTracker()
        
        let username = input.userNameText
            .do(onNext: { text in
                self.username = text
            })
        let password = input.passwordText
            .do(onNext: { text in
                self.password = text
            })
        
        let success = input.loginTap
            .asObservable()
            .filter { _ in
                self.username != nil && self.password != nil
            }
            .flatMap { _ -> Observable<[User]> in
                self.api.request(by: .login, body: LoginPostBody(username: self.username!, password: self.password!))
            }
            .map { $0.first }
            .trackError(errorTracker)
            .trackActivity(activityIndicator)
            .asDriverOnErrorJustComplete()
            .do(onNext: { (user: User?) in
                AppSingletone.shared.currentUser = user
                guard let user = user else {
                    return
                }
                _ = AppUserDefaults.currentUser.set(user)
                NotificationCenter.default.post(name: LoginViewModel.NotificationAuthorized, object: nil)
            })
            .mapToVoid()
        return Output(
            userNameText: username,
            passwordText: password,
            success: success,
            error: errorTracker.asDriver(),
            loading: activityIndicator.asDriver()
        )
    }
}
