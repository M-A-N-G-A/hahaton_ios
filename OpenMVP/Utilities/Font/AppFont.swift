//
//  AppFont.swift
//  OpenMVP
//
//  Created by Ayur Arkhipov on 27.11.2021.
//

import UIKit.UIFont

enum AppFont {
    case quickSand(FontFamilyConfiguration)
    case shreeDevangari714
    
    enum FontFamilyConfiguration {
        case bold
        case light
        case medium
        case regular
        case semibold
    }
    
    var font: UIFont {
        switch self {
        case .quickSand(let family):
            let fontProvider = FontFamilyProvider(family: Quicksand())
            switch family {
            case .bold:
                return fontProvider.bold
            case .light:
                return fontProvider.light
            case .medium:
                return fontProvider.medium
            case .regular:
                return fontProvider.regular
            case .semibold:
                return fontProvider.semibold
            }
        case .shreeDevangari714:
            return FontProvider(font: ShreeDevangari744()).font
        }
    }
}


