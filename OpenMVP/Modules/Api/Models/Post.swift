//
//  PostModel.swift
//  OpenMVP
//
//  Created by Ayur Arkhipov on 27.11.2021.
//

import Foundation

struct Post: Codable {
    let id = UUID()
    let comments: [String]?
    let datePosted: Date
    let notifs: [String]?
    let user: User?
    let userID: String?
    let liked: [User]?
    let content: String
    let media: String

    enum CodingKeys: String, CodingKey {
        case comments = "comments"
        case datePosted = "date_posted"
        case notifs = "notifs"
        case user = "us"
        case userID = "user_id"
        case liked = "liked"
        case content = "content"
        case media = "media"
    }
}

//struct Post {
//    let id: String = UUID().uuidString
//    let creator: User
//    let message: String
//    let image: String?
//    let views: Int
//    let time: Date
//    let likes: [User]
//    let messages: [Message]
//}

extension Post: Equatable {
    static func == (lhs: Post, rhs: Post) -> Bool {
        lhs.id == rhs.id
    }
}
