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
            
            let indexSelected: Driver<IndexPath>
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
            
            let indexSelected: Driver<IndexPath>
        }
    }
    
//    let stocks = [
//        Stock(title: "Doge-Coin", icon: "Doge.icon", description: "Doge coin is coin", value: 134),
//        Stock(title: "Apple", icon: "Apple.icon", description: "Apple stock is stock", value: 1344),
//        Stock(title: "Tesla", icon: "Tesla.icon", description: "Tesla stock is stock", value: 1348)
//    ]
    
    let navigator: HomeNavigatorProtocol
    let api: Api
    
    init(navigator: HomeNavigatorProtocol) {
        self.navigator = navigator
        self.api = Api()
    }
    
    private var dataSource: [HomeCellSectionModel] = []
    
    func transform(input: Input) -> Output {
        
        let fetchTrigger = Driver.merge(
            input.willAppear
        )
        
        let followedPosts = fetchTrigger
            .asObservable()
            .flatMap { _ -> Observable<[Post]> in
                let currentUserResult: Result<User, Error> = AppUserDefaults.currentUser.get()
                guard case let .success(user) = currentUserResult else {
                    return Observable.just([])
                }
                return self.api.requestArray(by: .followed(.posts(user.userName)))
            }
        
        let stocks = fetchTrigger
            .asObservable()
            .flatMap { _ -> Observable<[Stock]> in
                let currentUserResult: Result<User, Error> = AppUserDefaults.currentUser.get()
                guard case let .success(user) = currentUserResult else {
                    return Observable.just([])
                }
                return self.api.requestArray(by: .tickers(.byUserName(user.userName)))
            }
        
//        let dataSource = fetchTrigger
//            .asObservable()
//            .flatMap { _ -> Observable<[Post]> in
//                let currentUserResult: Result<User, Error> = AppUserDefaults.currentUser.get()
//                guard case let .success(user) = currentUserResult else {
//                    return Observable.just([])
//                }
////                return self.api.requestArray(by: .posts(.byName(user.userName)))
//                return self.api.requestArray(by: .followed(.posts(user.userName)))
//            }
//            .map { posts -> [HomeCellSectionModel] in
//                var dataSource: [HomeCellSectionModel] = []
////                dataSource.append(.stockSection(items: self.stocks.map {
////                    HomeCellSectionItem.stockSectionItem(stock: $0)
////                }))
//                dataSource.append(.postSection(items: posts.map { HomeCellSectionItem.postSectionItem(post: $0) }))
//                return dataSource
//            }
        let dataSource = Observable.zip(stocks, followedPosts)
            .flatMap { stocks, posts -> Observable<[HomeCellSectionModel]> in
                var dataSource: [HomeCellSectionModel] = []
                //                dataSource.append(.stockSection(items: self.stocks.map {
                //                    HomeCellSectionItem.stockSectionItem(stock: $0)
                //                }))
                dataSource.append(.stockSection(items: stocks.map { HomeCellSectionItem.stockSectionItem(stock: $0) }))
                dataSource.append(.postSection(items: posts.map { HomeCellSectionItem.postSectionItem(post: $0) }))
                return Observable.just(dataSource)
            }
            .do(onNext: { dataSource in
                self.dataSource = dataSource
            })
            .debug()
            //            .subscribeOn(SerialDispatchQueueScheduler(qos: .userInteractive))
            //            .observeOn(MainScheduler.instance)
            .asDriverOnErrorJustComplete()
        
        let indexSelected = input.cellActions.indexSelected
            .do(onNext: { indexPath in
//                Log.debug(self.dataSource)
                guard indexPath.section == 1 else { return }
                let postItems = self.dataSource[1].items
                switch postItems[indexPath.item] {
                case .stockSectionItem(stock: _):
                    Log.debug("nothing")
                case let .postSectionItem(post: post):
                    self.navigator.pushPost(with: post)
                }
            })
        
//        let followTap = input.cellActions
//            .followTap
//            .do(onNext: { post in
//                self.api.request(by: , body: <#T##Decodable & Encodable#>)
//            })
        
        return Output(
            dataSource: dataSource,
            
            cellActions: HomeViewModel.Output.PostCellActions(
                profileTap: input.cellActions.profileTap,
                followTap: input.cellActions.followTap,
                likeTap: input.cellActions.likeTap,
                messageTap: input.cellActions.messageTap,
                shareTap: input.cellActions.shareTap,
                bookmarkTap: input.cellActions.bookmarkTap,
            
                indexSelected: indexSelected
            )
        )
    }
}
