//
//  PostAddComment.swift
//  OpenMVP
//
//  Created by Ayur Arkhipov on 27.11.2021.
//

import Foundation

struct PostAddComment: Codable {
    let userId: String
    let content: String

    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case content = "content"
    }
}
