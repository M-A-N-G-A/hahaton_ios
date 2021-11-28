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
    let datePosted: Date?
    let notifs: [String]?
    let user: User?
    let userID: Int?
    let liked: [User]?
    let content: String
    let media: String?

    enum CodingKeys: String, CodingKey {
        case comments = "comments"
        case datePosted = "date_posted"
        case notifs = "notifs"
        case user = "user"
        case userID = "user_id"
        case liked = "liked"
        case content = "content"
        case media = "media"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        comments = try values.decode([String]?.self, forKey: .comments)
        let dateString = try values.decode(String.self, forKey: .datePosted)
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-ddTHH:mm:ss.SSS"
        dateFormat.date(from: dateString)
        Log.debug(dateString)
        Log.debug(dateFormat.date(from: dateString))
        datePosted = dateFormat.date(from: dateString)
        notifs = try values.decode([String]?.self, forKey: .notifs)
        liked = try values.decode([User]?.self, forKey: .liked)
//        user = try values.decode(User?.self, forKey: .user)
        user = nil
        userID = try values.decode(Int?.self, forKey: .userID)
        content = try values.decode(String.self, forKey: .content)
        media = try values.decode(String?.self, forKey: .media)
        }
}

extension Post: Equatable {
    static func == (lhs: Post, rhs: Post) -> Bool {
        lhs.id == rhs.id
    }
}
