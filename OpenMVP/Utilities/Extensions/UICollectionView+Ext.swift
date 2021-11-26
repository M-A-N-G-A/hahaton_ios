//
//  UICollectionView+Ext.swift
//  OpenMVP
//
//  Created by Ayur Arkhipov on 27.11.2021.
//

import UIKit

extension UICollectionView {
    func register(_ cellType: UICollectionViewCell.Type) {
        register(cellType, forCellWithReuseIdentifier: Utilities.classNameAsString(obj: cellType))
    }
    
    func dequeueReusableCell<CellType: UICollectionViewCell>(_ cellType: CellType.Type, by indexPath: IndexPath) -> CellType? {
        dequeueReusableCell(withReuseIdentifier: Utilities.classNameAsString(obj: cellType), for: indexPath) as? CellType
    }
}
