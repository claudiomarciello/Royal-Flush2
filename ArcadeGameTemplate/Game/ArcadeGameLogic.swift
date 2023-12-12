//
//  GameLogic.swift
//  ArcadeGameTemplate
//

import Foundation
import SwiftData

class ArcadeGameLogic: ObservableObject {
    
    // Single instance of the class
    static let shared: ArcadeGameLogic = ArcadeGameLogic()
    
    // Function responsible to set up the game before it starts.
    func setUpGame() {
        
        // TODO: Customize!
        
        self.currentScore = 0
        self.sessionDuration = 0
        
        self.isGameOver = false
        
        self.loadScores()
    }
    
    // Keeps track of the current score of the player
    @Published var currentScore: Int = 0
    // Keeps track of the last score of the player
    @Published var lastScore: Int = 0
    // Keeps track of the current combo's of the player
    @Published var currentCombo: Int = 0
    
    // Increases the score by a certain amount of points
    func score(points: Int) {
        
        // TODO: Customize!
        
        self.currentScore = self.currentScore + points
    }
    
    func combo(points: Int) {
        self.currentCombo += points
    }
    
    func resetCombo() {
        self.currentCombo = 0
    }
    
    // Keep tracks of the duration of the current session in number of seconds
    @Published var sessionDuration: TimeInterval = 0
    
    func increaseSessionTime(by timeIncrement: TimeInterval) {
        self.sessionDuration = self.sessionDuration + timeIncrement
    }
    
    func restartGame() {
        
        // TODO: Customize!
        
        self.setUpGame()
    }
    
    // Game Over Conditions
    @Published var isGameOver: Bool = false
    
    func finishTheGame() {
        if self.isGameOver == false {
            self.isGameOver = true
        }
        
        self.saveScores()
    }
    
    func loadScores() {
        Task { @MainActor in
            let context = GameData.shared.sharedModelContainer.mainContext
            let gameDataDescriptor = FetchDescriptor<GameDataModel>()
            
            if let gameData = try context.fetch(gameDataDescriptor).last {
                if let lastScore = gameData.achievements.last {
                    self.lastScore = lastScore.score
                }
            }
        }
    }
    
    func saveScores() {
        let currentScore = self.currentScore
        let lastScore = self.lastScore
        
        Task { @MainActor in
            let context = GameData.shared.sharedModelContainer.mainContext
            let gameDataDescriptor = FetchDescriptor<GameDataModel>()
            
            if let gameData = try context.fetch(gameDataDescriptor).first {
                if lastScore > currentScore {
                    gameData.achievements.append(AchievementModel(score: currentScore))
                    try context.save()
                }
            }
        }
    }
}
