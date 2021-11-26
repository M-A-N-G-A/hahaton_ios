//
//  AppColor.swift
//  OpenMVP
//
//  Created by Ayur Arkhipov on 27.11.2021.
//

import UIKit.UIColor

protocol ColorsProtocol {
    /// [ rgba(210, 214, 239, 1), rgba(146, 153, 194, 1) ]
    static var neumorphismLabelLinearGradient: [UIColor] { get }
}

struct AppColor: ColorsProtocol {
    static var neumorphismLabelLinearGradient: [UIColor] = [
        color("NeumorphismLinearGradientLabelStartColor") ?? rgba(210, 214, 239, 1),
        color("NeumorphismLinearGradientLabelEndColor") ?? rgba(146, 153, 194, 1)
    ]
    
    private static func color(_ name: String) -> UIColor? {
        UIColor(named: name)
    }
    
    private static func rgba(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat, _ alpha: CGFloat) -> UIColor {
        UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
}
