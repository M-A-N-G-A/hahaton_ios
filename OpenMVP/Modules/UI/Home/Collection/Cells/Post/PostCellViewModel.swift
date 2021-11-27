//
//  PostCellViewModel.swift
//  OpenMVP
//
//  Created by Ayur Arkhipov on 27.11.2021.
//

import UIKit
import RxSwift
import RxCocoa

final class PostCellViewModel: ViewModelType {
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
    }
        
    let model: Post
    let bookmarked: Bool
    
    init(model: Post, bookmarked: Bool) {
        self.model = model
        self.bookmarked = bookmarked
    }
    
    func transform(input: Input) -> Output {
        
        let profileImage = Driver.just(model.user?.imageFile)
            .map { $0?.image() }
            .compactMap { $0 }
        let profileName = Driver.just(model.user?.userName)
            .compactMap { $0 }
        let time = Driver.just(model.datePosted)
            .map { self.prepare(time: $0) }
        
        let message = Driver.just(model.content)
        let image = Driver.just(model.media)
            .map { $0.image() }
            .compactMap { $0 }
        let bookmarked = Driver.just(bookmarked)
        
        let likeUsers = Driver.just(model.liked)
            .compactMap { $0 }
        
        return Output(
            profile: PostCellViewModel.Output.Profile(
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
            bookmarkTap: input.bookmarkTap
        )
    }
}

// MARK: - Helpers
private extension PostCellViewModel {
    func prepare(time: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: time)
    }
}
