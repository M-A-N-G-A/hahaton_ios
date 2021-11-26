//
//  Utilities.swift
//  OpenMVP
//
//  Created by Ayur Arkhipov on 27.11.2021.
//

struct Utilities {
  static func classNameAsString(obj: Any) -> String {
    return String(describing: type(of: obj))
  }
}
