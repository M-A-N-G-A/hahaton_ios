//
//  ProfileViewModel.swift
//  OpenMVP
//
//  Created by Ayur Arkhipov on 27.11.2021.
//

import UIKit
import RxSwift
import RxCocoa

final class ProfileViewModel: ViewModelType {
    struct Input {
        
    }
    struct Output {
        
    }
    
    let navigator: ProfileNavigatorProtocol
    
    init(navigator: ProfileNavigatorProtocol) {
        self.navigator = navigator
    }
    
    func transform(input: Input) -> Output {
        Output()
    }
}
