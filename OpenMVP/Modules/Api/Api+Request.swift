//
//  Api+Request.swift
//  OpenMVP
//
//  Created by Ayur Arkhipov on 28.11.2021.
//

import Foundation
import RxSwift
import RxCocoa

extension Api {
    /// get
    func request<ResultType: Codable>(by route: Routes) -> Observable<ResultType> {
        return Observable.create { observer in
            guard let url = URL(string: makePath(route: route)) else {
                observer.onError(Errors.urlIsNil)
                return Disposables.create()
            }
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    observer.onError(error)
                    return
                }
                guard let data = data else { return }
                do {
                    let result = try jsonDecoder().decode(ResultType.self, from: data)
                    observer.onNext(result)
                    observer.onCompleted()
                } catch {
                    observer.onError(error)
                }
                
            }.resume()
            return Disposables.create()
        }
    }
    
    /// get
    func requestArray<ResultType: Codable>(by route: Routes) -> Observable<[ResultType]> {
        return Observable.create { observer in
            guard let url = URL(string: makePath(route: route)) else {
                observer.onError(Errors.urlIsNil)
                return Disposables.create()
            }
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    observer.onError(error)
                    return
                }
                guard let data = data else { return }
                do {
                    let result = try jsonDecoder().decode([ResultType].self, from: data)
                    observer.onNext(result)
                    observer.onCompleted()
                } catch {
                    observer.onError(error)
                }
                
            }.resume()
            return Disposables.create()
        }
    }
    
    /// post
    func request<ResultType: Codable, BodyType: Codable>(by route: Routes, body: BodyType) -> Observable<ResultType> {
        Observable.create { observer in
            guard let url = URL(string: makePath(route: route)) else {
                observer.onError(Errors.urlIsNil)
                return Disposables.create()
            }
            
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "POST"
            urlRequest.setValue("Application/json", forHTTPHeaderField: "Content-Type")
            
            do {
                let bodyData = try JSONEncoder().encode(body)
                urlRequest.httpBody = bodyData
            } catch {
                observer.onError(error)
            }
            
            URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                if let error = error {
                    observer.onError(error)
                    return
                }
                guard let data = data else { return }
                do {
                    let result = try jsonDecoder().decode(ResultType.self, from: data)
                    
                    observer.onNext(result)
                    observer.onCompleted()
                } catch {
                    observer.onError(error)
                }
                
            }.resume()
            return Disposables.create()
        }
    }
    
    /// without response
    func request<BodyType: Codable>(by route: Routes, body: BodyType) -> Observable<Void> {
        Observable.create { observer in
            guard let url = URL(string: makePath(route: route)) else {
                observer.onError(Errors.urlIsNil)
                return Disposables.create()
            }
            
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "POST"
            urlRequest.setValue("Application/json", forHTTPHeaderField: "Content-Type")
            
            do {
                let bodyData = try JSONEncoder().encode(body)
                urlRequest.httpBody = bodyData
            } catch {
                observer.onError(error)
            }
            
            URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                if let error = error {
                    observer.onError(error)
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else { return }
                guard (200...299).contains(httpResponse.statusCode) else {
                    observer.onError(Errors.withStatusCode(httpResponse.statusCode))
                    return
                }
                observer.onNext(())
                observer.onCompleted()
                
            }.resume()
            return Disposables.create()
        }
    }
    
    func requestImage(by fileName: String) -> Observable<UIImage> {
        Observable.create { observer in
            guard let url = URL(string: makeImagePath(name: fileName)) else {
                observer.onError(Errors.urlIsNil)
                return Disposables.create()
            }
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    observer.onError(error)
                    return
                }
                guard let data = data,
                      let image = UIImage(data: data) else {
                    observer.onError(Errors.decodeFail)
                    return
                }
                observer.onNext(image)
                observer.onCompleted()
                
            }.resume()
            return Disposables.create()
        }
    }
    
    func _requestImage(by fileName: String, complete: @escaping (Result<UIImage, Error>) -> Void) {
        guard let url = URL(string: makeImagePath(name: fileName)) else {
            complete(.failure(Errors.urlIsNil))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                complete(.failure(error))
            }
            guard let data = data,
                  let image = UIImage(data: data) else {
                complete(.failure(Errors.decodeFail))
                return
            }
            complete(.success(image))
        }.resume()
    }
}
