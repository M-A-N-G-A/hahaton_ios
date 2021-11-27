//
//  UITableView+Ext.swift
//  OpenMVP
//
//  Created by Ayur Arkhipov on 28.11.2021.
//

import UIKit

extension UITableView {
    func register(_ cellType: UITableViewCell.Type) {
        register(cellType, forCellReuseIdentifier: Utilities.classNameAsString(obj: cellType))
    }
    
    func dequeueReusableCell<CellType: UITableViewCell>(_ cellType: CellType.Type, by indexPath: IndexPath) -> CellType? {
        dequeueReusableCell(withIdentifier: Utilities.classNameAsString(obj: cellType), for: indexPath) as? CellType
    }
}
