//
//  UserDefaultsManager.swift
//  OpenMVP
//
//  Created by Ayur Arkhipov on 28.11.2021.
//

import Foundation

enum AppUserDefaults: String {
    
    case currentUser = "CurrentUser"
    
    func set<T: Codable>(_ obj: T) -> Result<T, Error> {
        do {
            let data = try JSONEncoder().encode(obj)
            UserDefaults.standard.set(data, forKey: self.rawValue)
            return .success(obj)
        } catch {
            return .failure(error)
        }
    }
    
    func get<T: Codable>() -> Result<T, Error> {
        do {
            guard let data = UserDefaults.standard.data(forKey: self.rawValue) else {
                return .failure(Errors.dataNotFound)
            }
            let obj = try JSONDecoder().decode(T.self, from: data)
            return .success(obj)
        } catch {
            return .failure(error)
        }
    }
    
    enum Errors: Error {
        case dataNotFound
    }
}
