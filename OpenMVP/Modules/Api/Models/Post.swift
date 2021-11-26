//
//  PostModel.swift
//  OpenMVP
//
//  Created by Ayur Arkhipov on 27.11.2021.
//

import Foundation

struct Post {
    let id: String = UUID().uuidString
    let creator: User
    let message: String
    let image: String?
    let views: Int
    let time: Date
    let likes: [User]
    let messages: [Message]
}

extension Post: Equatable {
    static func == (lhs: Post, rhs: Post) -> Bool {
        lhs.id == rhs.id
    }
}
