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
        let message: Driver<String?>
        let image: Driver<RemovableImageView.State>
        let imageThrow: Driver<UIImage?>
        
        let loading: Driver<Bool>
        let error: Driver<Error>
        let success: Driver<Void>
    }
    
    var message: String?
    var image: UIImage?
    
    let navigator: MakePostNavigatorProtocol
    
    init(navigator: MakePostNavigatorProtocol) {
        self.navigator = navigator
    }
    
    func transform(input: Input) -> Output {
        
        let activityIndicator = ActivityIndicator()
        let errorTracker = ErrorTracker()
        
        let message = input.message
            .do(onNext: { text in
                self.message = text
            })
        let imageToThrow = input.imageState
            .do(onNext: { state in
                switch state {
                case let .imageSelected(image):
                    self.image = image
                case .blank:
                    Log.debug("nothing")
                }
            })
            .map { _ in self.image }
        
        let success = input.postTap
            .asObservable()
            .filter {
                self.message != nil// && self.image != nil
            }
            .flatMap { _ -> Observable<Void> in
                let currentUserResult: Result<User, Error> = AppUserDefaults.currentUser.get()
                guard case let .success(user) = currentUserResult else {
                    return Observable.just(())
                }
                let body = PostCreateBody(user_id: user.uid, content: self.message!, media: "empty")
                return Api().request(by: .post(.create), body: body)
            }
            .debug()
            .mapToVoid()
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
            message: message,
            image: image,
            
            imageThrow: imageToThrow,
            
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
