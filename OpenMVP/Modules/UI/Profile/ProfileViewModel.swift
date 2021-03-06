//
//  ProfileViewModel.swift
//  OpenMVP
//
//  Created by Ayur Arkhipov on 27.11.2021.
//

import UIKit
import RxSwift
import RxCocoa

final class ProfileViewModel: ViewModelType {

    enum State {
        case me
        case other(User)
    }
    
    struct Input {
        let willAppear: Driver<Void>
        
        let actions: Actions
        struct Actions {
            let followTap: Driver<Void>
            let messageTap: Driver<Void>
            let editProfileTap: Driver<Void>
        }
    }
    struct Output {
        let image: Driver<UIImage>
        let followers: Driver<Int?>
        let name: Driver<String>
        let accuracy: Driver<Int?>
        let description: Driver<String>
        
        let stateForView: Driver<State>
        
        let posts: Driver<[Post]>
        
        let actions: Actions
        struct Actions {
            let followTap: Driver<Void>
            let messageTap: Driver<Void>
            let editProfileTap: Driver<Void>
        }
    }
    
    private let navigator: ProfileNavigatorProtocol
    private let api: Api
    
    let state: State
    
    init(navigator: ProfileNavigatorProtocol, state: State) {
        self.navigator = navigator
        self.state = state
        self.api = Api()
    }
    
    func transform(input: Input) -> Output {
        let fetchTrigger = input.willAppear
        let user = fetchTrigger
            .asObservable()
            .flatMap { _ -> Observable<User?> in
                var userName: String
                switch self.state {
                case .me:
                    let currentUserResult: Result<User, Error> = AppUserDefaults.currentUser.get()
                    guard case let .success(user) = currentUserResult else {
                        return .just(nil)
                    }
                    userName = user.userName
                case let .other(otherUser):
                    userName = otherUser.userName
                }
                return self.api.request(by: .users(.byName(userName)))
            }
            .compactMap { $0 }
//            .subscribeOn(SerialDispatchQueueScheduler(qos: .userInteractive))
//            .observeOn(MainScheduler.instance)
            .asDriverOnErrorJustComplete()
        let image = user
            .asObservable()
            .map { $0.imageFile }
            .flatMap { imageName -> Observable<UIImage> in
                self.api.requestImage(by: imageName)
            }
//            .subscribeOn(SerialDispatchQueueScheduler(qos: .userInteractive))
//            .observeOn(MainScheduler.instance)
            .asDriverOnErrorJustComplete()
        let followers = user
            .map { $0.followers?.count }
        let name = user
            .map { $0.userName }
        let accuracy = user
            .map { $0.accuracy }
        let description = user
            .map { $0.description }
            .compactMap { $0 }
        
        let posts = fetchTrigger
            .asObservable()
            .flatMap { _ -> Observable<[Post]> in
                let currentUserResult: Result<User, Error> = AppUserDefaults.currentUser.get()
                guard case let .success(user) = currentUserResult else {
                    return Observable.just([])
                }
                return self.api.requestArray(by: .posts(.byName(user.userName)))
            }
//            .subscribeOn(SerialDispatchQueueScheduler(qos: .userInteractive))
//            .observeOn(MainScheduler.instance)
            .asDriverOnErrorJustComplete()
        
        let editProfileTap = input.actions.editProfileTap
            .do(onNext: {
                self.navigator.pushEditProfile()
            })
        
        return Output(
            image: image,
            followers: followers,
            name: name,
            accuracy: accuracy,
            description: description,
            
            stateForView: Driver.just(self.state),
            
            posts: posts,
            
            actions: ProfileViewModel.Output.Actions(
                followTap: input.actions.followTap,
                messageTap: input.actions.messageTap,
                editProfileTap: editProfileTap
            )
        )
    }
}
