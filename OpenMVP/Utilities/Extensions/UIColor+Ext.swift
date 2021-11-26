//
//  UIColor.swift
//  OpenMVP
//
//  Created by Ayur Arkhipov on 27.11.2021.
//

import UIKit

extension UIColor {
    func image(_ size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { rendererContext in
            self.setFill()
            rendererContext.fill(CGRect(origin: .zero, size: size))
        }
    }
    
    func circleImage(_ size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { rendererContext in
            rendererContext.cgContext.setFillColor(self.cgColor)
            rendererContext.cgContext.setStrokeColor(self.cgColor)
            rendererContext.cgContext.setLineWidth(0)
            
            let rectangle = CGRect(origin: .zero, size: size)
            rendererContext.cgContext.addEllipse(in: rectangle)
            rendererContext.cgContext.drawPath(using: .fillStroke)
        }
    }
}
