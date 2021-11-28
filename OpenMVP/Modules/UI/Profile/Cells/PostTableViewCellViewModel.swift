//
//  PostTableViewViewModel.swift
//  OpenMVP
//
//  Created by Ayur Arkhipov on 28.11.2021.
//

import UIKit
import RxSwift
import RxCocoa

final class PostTableViewCellViewModel: ViewModelType {
    struct Input {
        let profileTap: Driver<Void>
        let followTap: Driver<Void>
        
        let likeTap: Driver<Void>
        let messageTap: Driver<Void>
        let shareTap: Driver<Void>
        let bookmarkTap: Driver<Void>
    }
    struct Output {
        let profile: Profile
        struct Profile {
            let image: Driver<UIImage>
            let name: Driver<String>
            let time: Driver<String>
        }
        
        let message: Driver<String>
        let image: Driver<UIImage>
        let bookmarked: Driver<Bool>
        
        let likeUsers: Driver<[User]>
        
        let profileTap: Driver<Void>
        let followTap: Driver<Void>
        
        let likeTap: Driver<Void>
        let messageTap: Driver<Void>
        let shareTap: Driver<Void>
        let bookmarkTap: Driver<Void>
        
        let profileState: Driver<ProfileViewModel.State>
    }
        
    let model: Post
    let bookmarked: Bool
    let profileState: ProfileViewModel.State
    
    init(model: Post, bookmarked: Bool, profileState: ProfileViewModel.State) {
        self.model = model
        self.bookmarked = bookmarked
        self.profileState = profileState
    }
    
    func transform(input: Input) -> Output {
        
        let profileImage = Observable.just(model.user?.imageFile)
            .compactMap { $0 }
            .flatMap { imageName -> Observable<UIImage> in
                Api().requestImage(by: imageName)
            }
            .asDriverOnErrorJustComplete()
        let profileName = Driver.just(model.user?.userName)
            .compactMap { $0 }
        let time = Driver.just(model.datePosted)
            .compactMap { $0 }
            .map { self.prepare(time: $0) }
        
        let message = Driver.just(model.content)
            .compactMap { $0 }
        let image = Driver.just(model.media)
            .compactMap { $0 }
            .asObservable()
            .flatMap { imageName -> Observable<UIImage> in
                Api().requestImage(by: imageName)
            }
            .debug()
            .compactMap { $0 }
            .asDriverOnErrorJustComplete()
        let bookmarked = Driver.just(bookmarked)
        
        let likeUsers = Driver.just(model.liked)
            .compactMap { $0 }
        
        return Output(
            profile: PostTableViewCellViewModel.Output.Profile(
                image: profileImage,
                name: profileName,
                time: time
            ),
            
            message: message,
            image: image,
            bookmarked: bookmarked,
            
            likeUsers: likeUsers,
            
            profileTap: input.profileTap,
            followTap: input.followTap,
            likeTap: input.likeTap,
            messageTap: input.messageTap,
            shareTap: input.shareTap,
            bookmarkTap: input.bookmarkTap,
            
            profileState: Driver.just(self.profileState)
        )
    }
}

// MARK: - Helpers
private extension PostTableViewCellViewModel {
    func prepare(time: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: time)
    }
}
