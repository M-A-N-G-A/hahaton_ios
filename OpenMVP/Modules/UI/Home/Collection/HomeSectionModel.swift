//
//  HomeSectionModel.swift
//  OpenMVP
//
//  Created by Ayur Arkhipov on 27.11.2021.
//

import RxDataSources

enum HomeCellSectionItem {
    case stockSectionItem(stock: Stock)
    case postSectionItem(post: Post)
}

extension HomeCellSectionItem: Equatable {
    static func == (lhs: HomeCellSectionItem, rhs: HomeCellSectionItem) -> Bool {
        switch (lhs, rhs) {
        case let (.stockSectionItem(stock: lStock), .stockSectionItem(stock: rStock)):
            return lStock == rStock
            
        case let (.postSectionItem(post: lPost), .postSectionItem(post: rPost)):
            return lPost == rPost
            
        default:
            return false
        }
    }
}

enum HomeCellSectionModel {
    case stockSection(items: [HomeCellSectionItem])
    case postSection(items: [HomeCellSectionItem])
}

extension HomeCellSectionModel: SectionModelType {
    typealias Item = HomeCellSectionItem
    
    var items: [Item] {
        switch  self {
        case .stockSection(items: let items):
            return items.map { $0 }
        case .postSection(items: let items):
            return items.map { $0 }
        }
    }
    
    init(original: HomeCellSectionModel, items: [Item]) {
        switch original {
        case .stockSection(items: _):
            self = .stockSection(items: items)
        case .postSection(items: _):
            self = .postSection(items: items)
        }
    }
}
