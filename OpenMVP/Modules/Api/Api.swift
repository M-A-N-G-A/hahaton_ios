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
        
        case followed(Followed)
        enum Followed: RoutePath {
            /// get: username: String
            case posts(String)
            
            var path: String {
                switch self {
                case let .posts(username):
                    return "" + username
                }
            }
        }
        
        /// post
        case login
        
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
        
        case post(Post)
        enum Post: RoutePath {
            case create
            
            var path: String {
                switch self {
                case .create:
                    return "create"
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
            case let .followed(followed):
                return "followed/" + followed.path
            case .login:
                return "login"
            case let .post(post):
                return "post/" + post.path
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
    static let imageRoute = "http://gennadis.pythonanywhere.com"
    
    func makePath(route: Routes) -> String {
        let route = Api.route + route.path
        Log.debug(route)
        return route
    }
    
    func makeImagePath(name: String) -> String {
        let route = Api.imageRoute + name
        Log.debug(route)
        return route
    }
    
    func jsonDecoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        return decoder
    }
    
    enum Errors: Error {
        case urlIsNil
        case decodeFail
        case encodeFail
        case withStatusCode(Int)
    }
}
