//
//  GameDataModel.swift
//  Royal Flush
//
//  Created by Alexandr Chubutkin on 12/12/23.
//

import Foundation
import SwiftData

@Model
class GameDataModel {
    var achievements: [AchievementModel]
    
    init(achievements: [AchievementModel]) {
        self.achievements = achievements
    }
}

@Model class AchievementModel {
    var timestamp: Date
    var score: Int
    var combo: Int
    
    init(timestamp: Date = Date.now, score: Int, combo: Int) {
        self.timestamp = timestamp
        self.score = score
        self.combo = combo
    }
}
