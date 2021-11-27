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
    struct Input {
        let willAppear: Driver<Void>
        
        let actions: Actions
        struct Actions {
            let followTap: Driver<Void>
            let messageTap: Driver<Void>
        }
    }
    struct Output {
        let image: Driver<UIImage>
        let followers: Driver<Int?>
        let name: Driver<String>
        let accuracy: Driver<Int?>
        let description: Driver<String>
        
        let actions: Actions
        struct Actions {
            let followTap: Driver<Void>
            let messageTap: Driver<Void>
        }
    }
    
    private let navigator: ProfileNavigatorProtocol
    private let api: Api
    
    init(navigator: ProfileNavigatorProtocol) {
        self.navigator = navigator
        self.api = Api()
    }
    
    func transform(input: Input) -> Output {
        let fetchTrigger = input.willAppear
        let user = fetchTrigger
//            .flatMap { _ -> SharedSequence<DriverSharingStrategy, [User]> in
//                self.api.requestArray(by: .users(.byName("investor1"))).asDriverOnErrorJustComplete()
//            }
            .map {
                self.api.requestArray(by: .users(.byName("investor1")))
            }
            .debug()
            .map { $0.first }
            .compactMap { $0 }
        let image = user
            .map { $0.imageFile.image() }
            .compactMap { $0 }
        let followers = user
            .map { $0.followers?.count }
        let name = user
            .map { $0.userName }
        let accuracy = user
            .map { $0.accuracy }
        let description = user
            .map { $0.description }
            .compactMap { $0 }
        
        return Output(
            image: image,
            followers: followers,
            name: name,
            accuracy: accuracy,
            description: description,
            
            actions: ProfileViewModel.Output.Actions(
                followTap: input.actions.followTap,
                messageTap: input.actions.messageTap
            )
        )
    }
}
