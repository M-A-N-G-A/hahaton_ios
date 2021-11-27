//
//  UserModel.swift
//  OpenMVP
//
//  Created by Ayur Arkhipov on 27.11.2021.
//

import UIKit

struct User {
    let id: String = UUID().uuidString
    let userName: String
    let accuracy: Float?
    let description: String?
    let email: String
    let followers: Int?
    let profileIcon: String?
    
    init(userName: String, accuracy: Float = 0, description: String? = nil, email: String = "", followers: Int? = nil, profileIcon: String? = nil) {
        self.userName = userName
        self.accuracy = accuracy
        self.description = description
        self.email = email
        self.followers = followers
        self.profileIcon = profileIcon
    }
}

extension User: Equatable {
    static func == (lhs: User, rhs: User) -> Bool {
        lhs.id == rhs.id
    }
}
