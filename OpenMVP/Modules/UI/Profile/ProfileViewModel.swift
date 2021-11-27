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
        let accuracy: Driver<Float?>
        let description: Driver<String>
        
        let actions: Actions
        struct Actions {
            let followTap: Driver<Void>
            let messageTap: Driver<Void>
        }
    }
    
    let navigator: ProfileNavigatorProtocol
    
    init(navigator: ProfileNavigatorProtocol) {
        self.navigator = navigator
    }
    
    func transform(input: Input) -> Output {
        let fetchTrigger = input.willAppear
        let user = fetchTrigger
            .map { User(userName: "Vasya", accuracy: 76, description: " это текст-рыба, часто используемый в печати и вэб-дизайне. Lorem Ipsum является стандартной рыбой для текстов на латинице с начала XVI века. В то время некий безымянный печатник создал большую коллекцию размеров и форм шрифтов, используя Lorem Ipsum для распечатки образцов. Lorem Ipsum не только успешно пережил без заметных изменений пять веков, но и перешагнул в электронный дизайн. Его популяризации в новое время послужили публикация листов Letraset с образцами Lorem Ipsum в 60-х годах и, в более недавнее время, программы электронной вёрстки типа Aldus PageMaker, в шаблонах которых используется Lorem Ipsum.", email: "vasya@gmail.com", followers: 32, profileIcon: "VasyaIcon.png") } // Api call
        let image = user
            .map { $0.profileIcon?.image() }
            .compactMap { $0 }
        let followers = user
            .map { $0.followers }
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
