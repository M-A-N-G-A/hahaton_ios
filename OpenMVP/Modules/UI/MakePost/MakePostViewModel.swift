//
//  MakePostViewModel.swift
//  OpenMVP
//
//  Created by Ayur Arkhipov on 27.11.2021.
//

import UIKit
import RxSwift
import RxCocoa
import RxAlamofire

final class MakePostViewModel: ViewModelType {
    struct Input {
        let message: Driver<String?>
        let imageState: Driver<RemovableImageView.State>
        
        let postTap: Driver<Void>
        let imageTap: Driver<Void>
        let deleteTap: Driver<Void>
    }
    struct Output {
        let image: Driver<RemovableImageView.State>
        
        let loading: Driver<Bool>
        let error: Driver<Error>
        let success: Driver<Void>
    }
    
    let navigator: MakePostNavigatorProtocol
    
    init(navigator: MakePostNavigatorProtocol) {
        self.navigator = navigator
    }
    
    func transform(input: Input) -> Output {
        
        let activityIndicator = ActivityIndicator()
        let errorTracker = ErrorTracker()
        
        let success = input.postTap
            .flatMap {
                Driver.combineLatest(input.message, input.imageState.startWith(.blank))
            }
            .do(onNext: { (message, image) in
                Log.debug(message)
                Log.debug(image)
            })
//            .flatMap { _ -> SharedSequence<DriverSharingStrategy, Void> in
//                Api().request(by: .comments(.toPostById("1")), body: postAddComment).asDriverOnErrorJustComplete()
//            }
            .mapToVoid() // request api
            .throttle(.seconds(5))
            .trackActivity(activityIndicator)
            .trackError(errorTracker)
            .asDriverOnErrorJustComplete()
        
        let importedState = input.imageTap
            .asObservable()
            .flatMap { self.importImage() }
            .map { image in RemovableImageView.State.imageSelected(image) }
            .subscribeOn(SerialDispatchQueueScheduler(qos: .userInteractive))
            .observeOn(MainScheduler.instance)
            .asDriverOnErrorJustComplete()
        
        let deleteState = input.deleteTap
            .map { RemovableImageView.State.blank }
        
        let image = Driver.merge(importedState, deleteState)
        
        return Output(
            image: image,
            
            loading: activityIndicator.asDriver(),
            error: errorTracker.asDriver(),
            success: success
        )
    }
}

// MARK: - Helpers
private extension MakePostViewModel {
    func importImage() -> Observable<UIImage> {
        Observable.create { observable in
            self.navigator.importImage { result in
                switch result {
                case let .success(image):
                    observable.onNext(image)
                    observable.onCompleted()
                case let .failure(error):
                    observable.onError(error)
                }
            }
            return Disposables.create()
        }
    }
}
