//
//  Localizable.swift
//  OpenMVP
//
//  Created by Ayur Arkhipov on 27.11.2021.
//

import Foundation

public protocol Localizable : RawRepresentable where Self.RawValue == String {

    var localized: String { get }
    
    func localized(with arguments: CVarArg...) -> String
}

extension Localizable {
    public var localized: String {
        rawValue.localized()
    }
    
    public func localized(with arguments: CVarArg...) -> String {
      let localized = rawValue.localized()
      
      let clos = unsafeBitCast(String.localizedStringWithFormat,
                               to: ((String, [CVarArg]) -> String).self)
      return clos(localized, arguments)
    }
}

public extension String {
    func localized() -> String {
        NSLocalizedString(self, comment: "\(self) comment")
    }
}
