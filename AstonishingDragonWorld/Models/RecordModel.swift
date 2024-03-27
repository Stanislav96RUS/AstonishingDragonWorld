//
//  RecordModel.swift
//  AstonishingDragonWorld
//
//  Created by Stanislav on 12.03.2024.
//

import Foundation

final class UserRecordModel : Codable {
    var name: String
    var userAvatar: String
    var point: Int
    var date: String
    
    init(name: String, userAvatar: String, point: Int, date: String) {
        self.name = name
        self.userAvatar = userAvatar
        self.point = point
        self.date = date
    }
}
