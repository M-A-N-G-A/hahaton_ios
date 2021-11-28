//
//  String+Ext.swift
//  OpenMVP
//
//  Created by Ayur Arkhipov on 27.11.2021.
//

import UIKit

extension String {
    
    func image(withAttributes attributes: [NSAttributedString.Key: Any]? = nil, size: CGSize? = nil) -> UIImage? {
        let size = size ?? (self as NSString).size(withAttributes: attributes)
        return UIGraphicsImageRenderer(size: size).image { _ in
            (self as NSString).draw(in: CGRect(origin: .zero, size: size),
                                    withAttributes: attributes)
        }
    }
    
    func addQuery(field: String, value: String) -> Self {
        guard self.contains("?") else {
            return self + "?" + field + "=" + value
        }
        return self + "&" + field + "=" + value
    }
    
    func addQuery(field: String, value: Any?) -> Self {
        guard let value = value else { return self }
        guard self.contains("?") else {
            return self + "?" + field + "=" + String(describing: value)
        }
        return self + "&" + field + "=" + String(describing: value)
    }
    
}
