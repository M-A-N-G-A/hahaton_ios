//
//  Api.swift
//  OpenMVP
//
//  Created by Ayur Arkhipov on 27.11.2021.
//

import RxSwift
import RxCocoa

protocol RoutePath {
    var path: String { get }
}

struct Api {
    enum Routes: RoutePath {
        
        case comments(Comments)
        enum Comments: RoutePath {
            /// post: id of post
            case toPostById(String)
            
            var path: String {
                switch self {
                case let .toPostById(id):
                    return "" + id
                }
            }
        }
        
        case posts(Posts)
        enum Posts: RoutePath {
            /// get
            case byName(String)
            
            var path: String {
                switch self {
                case let .byName(name):
                    return "" + name
                }
            }
        }
        
        case users(Users)
        enum Users: RoutePath {
            /// get. `user is nil`, `userId displayed`
            case byName(String)
            
            var path: String {
                switch self {
                case let .byName(name):
                    return "" + name
                }
            }
        }
        
        var path: String {
            switch self {
            case let .posts(post):
                return "posts/" + post.path
            case let .users(user):
                return "users/" + user.path
            case let .comments(comment):
                return "comments/" + comment.path
            }
        }
    }
    
    static let route = "http://gennadis.pythonanywhere.com/api/v1/"
    static let imageRoute = "http://gennadis.pythonanywhere.com/"
    
    private func makePath(route: Routes) -> String {
        let route = Api.route + route.path
        Log.debug(route)
        return route
    }
    
    /// get
    func request<ResultType: Codable>(by route: Routes) -> Observable<ResultType> {
        return Observable.create { observer in
            guard let url = URL(string: makePath(route: route)) else {
                observer.onError(Errors.urlIsNil)
                return Disposables.create()
            }
            Log.thisFunction()
            Log.debug(url)
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    observer.onError(error)
                    return
                }
                guard let data = data else { return }
                do {
                    Log.debug(response)
                    Log.debug(data)
                    let result = try JSONDecoder().decode(ResultType.self, from: data)
                    Log.debug(result)
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
            Log.thisFunction()
            Log.debug(url)
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    observer.onError(error)
                    return
                }
                guard let data = data else { return }
                do {
                    Log.debug(response)
                    Log.debug(data)
                    let result = try JSONDecoder().decode([ResultType].self, from: data)
                    Log.debug(result)
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
                    let result = try JSONDecoder().decode(ResultType.self, from: data)
                    
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
    
    enum Errors: Error {
        case urlIsNil
        case decodeFail
        case encodeFail
        case withStatusCode(Int)
    }
}

fileprivate extension String {
    func addQuery(field: String, value: String) -> Self {
        guard self.contains("?") else {
            return self + "?" + field + "=" + value
        }
        return self + "&" + field + "=" + value
    }
    
    func addQuery(field: String, value: Any?) -> Self {
        guard let value = value else { return self }
        guard self.contains("?") else {
            return self + "?" + field + "=" + String(describing: value)
        }
        return self + "&" + field + "=" + String(describing: value)
    }
}
