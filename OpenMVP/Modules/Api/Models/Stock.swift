//
//  StockModel.swift
//  OpenMVP
//
//  Created by Ayur Arkhipov on 27.11.2021.
//

import Foundation

struct Stock: Codable {
    let id = UUID()
    let logo: String
    let price: Double
    let priceChange: Double
    let summary: String
    let ticker: String

    enum CodingKeys: String, CodingKey {
        case logo = "logo"
        case price = "price"
        case priceChange = "price_change"
        case summary = "summary"
        case ticker = "ticker"
    }
}

extension Stock: Equatable {
    static func == (lhs: Stock, rhs: Stock) -> Bool {
        lhs.id == rhs.id
    }
}
