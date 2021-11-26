//
//  ViewModelType.swift
//  OpenMVP
//
//  Created by Ayur Arkhipov on 27.11.2021.
//

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}
