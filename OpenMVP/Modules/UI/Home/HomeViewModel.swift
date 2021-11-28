//
//  HomeViewModel.swift
//  OpenMVP
//
//  Created by Ayur Arkhipov on 27.11.2021.
//

import UIKit
import RxSwift
import RxCocoa

final class HomeViewModel: ViewModelType {
    struct Input {
        let willAppear: Driver<Void>
        
        let cellActions: PostCellActions
        struct PostCellActions {
            let profileTap: Driver<Post>
            let followTap: Driver<Post>
            
            let likeTap: Driver<Post>
            let messageTap: Driver<Post>
            let shareTap: Driver<Post>
            let bookmarkTap: Driver<Post>
        }
    }
    struct Output {
        let dataSource: Driver<[HomeCellSectionModel]>
        
        let cellActions: PostCellActions // TODO: delete may be
        struct PostCellActions {
            let profileTap: Driver<Post>
            let followTap: Driver<Post>
            
            let likeTap: Driver<Post>
            let messageTap: Driver<Post>
            let shareTap: Driver<Post>
            let bookmarkTap: Driver<Post>
        }
    }
    
    let stocks = [
        Stock(title: "Doge-Coin", icon: "Doge.icon", description: "Doge coin is coin", value: 134),
        Stock(title: "Apple", icon: "Apple.icon", description: "Apple stock is stock", value: 1344),
        Stock(title: "Tesla", icon: "Tesla.icon", description: "Tesla stock is stock", value: 1348)
    ]
    
//    let posts = [
//        Post(comments: [], datePosted: Date(), notifs: [], user: User(userName: "Vasya", accuracy: "33", description: "Nope", email: "nope", imageFile: "nope", followers: []), userID: "nope", liked: [], content: "nope", media: "nope"),
//        Post(comments: [], datePosted: Date(), notifs: [], user: User(userName: "Vasya", accuracy: "33", description: "Nope", email: "nope", imageFile: "nope", followers: []), userID: "nope", liked: [], content: "nope", media: "nope"),
//        Post(comments: [], datePosted: Date(), notifs: [], user: User(userName: "Vasya", accuracy: "33", description: "Nope", email: "nope", imageFile: "nope", followers: []), userID: "nope", liked: [], content: "nope", media: "nope"),
//        Post(comments: [], datePosted: Date(), notifs: [], user: User(userName: "Vasya", accuracy: "33", description: "Nope", email: "nope", imageFile: "nope", followers: []), userID: "nope", liked: [], content: "nope", media: "nope"),
//        Post(comments: [], datePosted: Date(), notifs: [], user: User(userName: "Vasya", accuracy: "33", description: "Nope", email: "nope", imageFile: "nope", followers: []), userID: "nope", liked: [], content: "nope", media: "nope"),
//        Post(comments: [], datePosted: Date(), notifs: [], user: User(userName: "Vasya", accuracy: "33", description: "Nope", email: "nope", imageFile: "nope", followers: []), userID: "nope", liked: [], content: "nope", media: "nope"),
//        Post(comments: [], datePosted: Date(), notifs: [], user: User(userName: "Vasya", accuracy: "33", description: "Nope", email: "nope", imageFile: "nope", followers: []), userID: "nope", liked: [], content: "nope", media: "nope"),
//        Post(comments: [], datePosted: Date(), notifs: [], user: User(userName: "Vasya", accuracy: "33", description: "Nope", email: "nope", imageFile: "nope", followers: []), userID: "nope", liked: [], content: "nope", media: "nope"),
//        Post(comments: [], datePosted: Date(), notifs: [], user: User(userName: "Vasya", accuracy: "33", description: "Nope", email: "nope", imageFile: "nope", followers: []), userID: "nope", liked: [], content: "nope", media: "nope"),
//        Post(comments: [], datePosted: Date(), notifs: [], user: User(userName: "Vasya", accuracy: "33", description: "Nope", email: "nope", imageFile: "nope", followers: []), userID: "nope", liked: [], content: "nope", media: "nope")
//    ]
    
    let navigator: HomeNavigatorProtocol
    let api: Api
    
    init(navigator: HomeNavigatorProtocol) {
        self.navigator = navigator
        self.api = Api()
    }
    
    func transform(input: Input) -> Output {
        
        let fetchTrigger = Driver.merge(
            input.willAppear
        )
        
        let dataSource = fetchTrigger
            .asObservable()
            .flatMap { _ -> Observable<[Post]> in
                let currentUserResult: Result<User, Error> = AppUserDefaults.currentUser.get()
                guard case let .success(user) = currentUserResult else {
                    return Observable.just([])
                }
                return self.api.requestArray(by: .posts(.byName(user.userName)))
            }
            .map { posts -> [HomeCellSectionModel] in
                var dataSource: [HomeCellSectionModel] = []
                dataSource.append(.stockSection(items: self.stocks.map {
                    HomeCellSectionItem.stockSectionItem(stock: $0)
                }))
                dataSource.append(.postSection(items: posts.map { HomeCellSectionItem.postSectionItem(post: $0) }))
                return dataSource
            }
            .asDriverOnErrorJustComplete()
        
        return Output(
            dataSource: dataSource,
            
            cellActions: HomeViewModel.Output.PostCellActions(
                profileTap: input.cellActions.profileTap,
                followTap: input.cellActions.followTap,
                likeTap: input.cellActions.likeTap,
                messageTap: input.cellActions.messageTap,
                shareTap: input.cellActions.shareTap,
                bookmarkTap: input.cellActions.bookmarkTap)
        )
    }
}
