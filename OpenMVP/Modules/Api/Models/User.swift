//
//  UserModel.swift
//  OpenMVP
//
//  Created by Ayur Arkhipov on 27.11.2021.
//

import UIKit

struct User: Codable {
    let id = UUID()
    let userName: String
    let accuracy: String?
    let description: String?
    let email: String
    let imageFile: String
    let followers: [User]? // check it

    enum CodingKeys: String, CodingKey {
        case userName = "username"
        case accuracy = "accuracy"
        case description = "description"
        case email = "email"
        case imageFile = "image_file"
        case followers = "followers"
    }
}
extension User: Equatable {
    static func == (lhs: User, rhs: User) -> Bool {
        lhs.id == rhs.id
    }
}
