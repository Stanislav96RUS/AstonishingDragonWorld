//
//  UserModel.swift
//  AstonishingDragonWorld
//
//  Created by Stanislav on 12.03.2024.
//

import Foundation

final class UserModel : Codable {
    var name: String
    var userAvatar: String
    var colorDragon: String
    var typeObstacles: String
    var difficultyGameSpeed: TimeInterval
    var difficultyGameIntensity: TimeInterval
    var colorDragonSegmentedValue: Int
    var obstaclesSegmentedValue: Int
    var difficultySegmentedValue: Int 
    
    init(name: String,
         userAvatar: String,
         colorDragon: String,
         typeObstacles: String,
         difficultyGameSpeed: TimeInterval,
         difficultyGameIntensity: TimeInterval,
         colorDragonSegmentedValue: Int,
         obstaclesSegmentedValue: Int,
         difficultySegmentedValue: Int) {
        self.name = name
        self.colorDragon = colorDragon
        self.userAvatar = userAvatar
        self.typeObstacles = typeObstacles
        self.difficultyGameSpeed = difficultyGameSpeed
        self.difficultyGameIntensity = difficultyGameIntensity
        self.colorDragonSegmentedValue = colorDragonSegmentedValue
        self.obstaclesSegmentedValue = obstaclesSegmentedValue
        self.difficultySegmentedValue = difficultySegmentedValue
    }
}
