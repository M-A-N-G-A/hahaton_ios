//
//  HomeViewModel.swift
//  OpenMVP
//
//  Created by Ayur Arkhipov on 27.11.2021.
//

import UIKit
import RxSwift
import RxCocoa

final class HomeViewModel: ViewModelType {
    struct Input {
        
    }
    struct Output {
        
    }
    
    let navigator: HomeNavigatorProtocol
    
    init(navigator: HomeNavigatorProtocol) {
        self.navigator = navigator
    }
    
    func transform(input: Input) -> Output {
        Output()
    }
}
