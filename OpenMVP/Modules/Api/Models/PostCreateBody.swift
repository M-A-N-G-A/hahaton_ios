//
//  PostCreateBody.swift
//  OpenMVP
//
//  Created by Ayur Arkhipov on 28.11.2021.
//

import Foundation

struct PostCreateBody: Codable {
    let user_id: Int
    let content: String
    let media: String
}
