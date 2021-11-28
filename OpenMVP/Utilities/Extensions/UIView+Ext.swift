//
//  UIView+Ext.swift
//  OpenMVP
//
//  Created by Ayur Arkhipov on 27.11.2021.
//

import UIKit.UIView

extension UIView {
    func add(subviews: UIView...) {
        subviews.forEach { addSubview($0) }
    }
    
    func addAndFill(_ view: UIView) {
        addSubview(view)
        view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
