//
//  StorageService.swift
//  AstonishingDragonWorld
//
//  Created by Stanislav on 12.03.2024.
//

import Foundation
import UIKit

private extension String {
    static let keyUser = "user"
    static let keyRecord = "record"
}

final class StorageService {
    
    static let shared = StorageService()
    private init() {}
    
    func saveUser(_ user: UserModel) {
        let data = try? JSONEncoder().encode(user)
        UserDefaults.standard.set(data, forKey: .keyUser)
    }
    
    func loadUser() -> UserModel? {
        guard let data = UserDefaults.standard.value(forKey: .keyUser) as? Data else {
            return nil
        }
        let user = try? JSONDecoder().decode(UserModel.self, from: data)
        return user
    }
    func saveUsersRecords (_ record: [UserRecordModel]) {
        let data = try? JSONEncoder().encode(record)
        UserDefaults.standard.set(data, forKey: .keyRecord)
    }
    
    func loadUsersRecords() -> [UserRecordModel]? {
        guard let data = UserDefaults.standard.value(forKey: .keyRecord) as? Data else {
            return nil
        }
        let user = try? JSONDecoder().decode([UserRecordModel].self, from: data)
        return user
    }
    
    func getSavedImage(named: String) -> UIImage? {
        if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
            return UIImage(contentsOfFile: URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(named).path)
        }
        return nil
    }
}
