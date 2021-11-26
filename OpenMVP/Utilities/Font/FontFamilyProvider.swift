//
//  FontFamilyProvider.swift
//  OpenMVP
//
//  Created by Ayur Arkhipov on 27.11.2021.
//

import UIKit.UIFont

protocol FontFamilyProviderProtocol {
    
    var regular: String { get }
    
    var semibold: String { get }
    
    var bold: String { get }
    
    var light: String { get }
    
    var medium: String { get }
}

struct Quicksand: FontFamilyProviderProtocol {
    
    var regular: String { "Quicksand-Regular" }
    
    var semibold: String { "Quicksand-SemiBold" }
    
    var bold: String { "Quicksand-Bold" }
    
    var light: String { "Quicksand-Light" }
    
    var medium: String { "Quicksand-Medium" }
    
}

class FontFamilyProvider {
        
    var regular: UIFont { font(name: fontsProvider.regular) }
    
    var semibold: UIFont { font(name: fontsProvider.semibold) }
    
    var bold: UIFont { font(name: fontsProvider.bold) }
    
    var light: UIFont { font(name: fontsProvider.light) }
    
    var medium: UIFont { font(name: fontsProvider.medium) }
    
    private let fontsProvider: FontFamilyProviderProtocol
    
    init(family: FontFamilyProviderProtocol) {
        self.fontsProvider = family
    }
        
    private func font(name: String) -> UIFont {
        return UIFont(name: name, size: 15) ?? .systemFont(ofSize: 15)
    }
}
