//
//  StockModel.swift
//  OpenMVP
//
//  Created by Ayur Arkhipov on 27.11.2021.
//

import Foundation

struct Stock {
    let id: String = UUID().uuidString
    let title: String
    let icon: String
    let description: String
    let value: Float
}

extension Stock: Equatable {
    static func == (lhs: Stock, rhs: Stock) -> Bool {
        lhs.id == rhs.id
    }
}
