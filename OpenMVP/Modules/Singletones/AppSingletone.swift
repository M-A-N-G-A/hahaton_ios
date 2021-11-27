//
//  AppSingletone.swift
//  OpenMVP
//
//  Created by Ayur Arkhipov on 28.11.2021.
//

import Foundation

final class AppSingletone {
    
    static let shared = AppSingletone()
    
    var currentUser: User?
    
}
