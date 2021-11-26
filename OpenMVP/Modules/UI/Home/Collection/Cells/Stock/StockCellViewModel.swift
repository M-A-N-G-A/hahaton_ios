//
//  StockViewModel.swift
//  OpenMVP
//
//  Created by Ayur Arkhipov on 27.11.2021.
//

import UIKit
import RxSwift
import RxCocoa

final class StockCellViewModel: ViewModelType {
    struct Input {
        
    }
    struct Output {
        let icon: Driver<UIImage>
        let title: Driver<String>
        let value: Driver<String>
    }
        
    let model: Stock
    
    init(model: Stock) {
        self.model = model
    }
    
    func transform(input: Input) -> Output {
        let icon = Driver.just(model.icon.image())
            .compactMap { $0 }
        let title = Driver.just(model.title)
        let value = Driver.just(model.value)
            .map { self.prepare(value: $0) }
        
        return Output(
            icon: icon,
            title: title,
            value: value
        )
    }
}

// MARK: - Helpers
private extension StockCellViewModel {
    func prepare(value: Float) -> String {
        "$\(value)"
    }
}
