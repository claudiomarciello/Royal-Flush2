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
        self.bestGames = []
        self.currentScore = -500
        self.currentCombo = 0
        self.sessionDuration = 0
        
        self.isGameOver = false
        resetCombo()
        self.saveScores{}
        self.loadScores{}
    }
    
    // Keeps track of the current score of the player
    @Published var currentScore: Int = 0
    // Keeps track of the last score of the player
    @Published var lastScore: Int = 0
    
    @Published var bestScore: Int = 0
    // Keeps track of the current combo's of the player
    @Published var currentCombo: Int = 0
    
    @Published var bestCombo: Int = 0
    @Published var name: String = "Default"
    @Published var bestGames: [AchievementModel] = []
    
    
    // Increases the score by a certain amount of points
    func score(points: Int) {
        
        // TODO: Customize!
        
        self.currentScore = self.currentScore + points
    }
    
    func combo(points: Int) {
        self.currentCombo += points
    }
    
    func InsertName(name: String){
        self.name = name
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
        
        self.setUpGame()
        
    }
    
    // Game Over Conditions
    @Published var isGameOver: Bool = false
    
    func finishTheGame(){
        if self.isGameOver == false {
            self.saveScores{
                self.loadScores{
                    
                    self.isGameOver = true}}
        }
        
        
        
    }
    
    func loadScores(completion: @escaping () -> Void) {
        Task { @MainActor in
            let context = GameData.shared.sharedModelContainer.mainContext
            let gameDataDescriptor = FetchDescriptor<GameDataModel>()
            
            if let gameData = try context.fetch(gameDataDescriptor).last {
                if let lastScore = gameData.achievements.last {
                    self.lastScore = lastScore.score
                }
                
                let sortedScores = gameData.achievements.sorted { $0.score > $1.score }
                var bestScores: [AchievementModel] = []
                
                if sortedScores.count >= 1 {
                    bestScore = sortedScores[0].score
                    bestScores.append(sortedScores[0])
                }
                if sortedScores.count >= 2{
                    bestScores.append(sortedScores[1])
                }
                if sortedScores.count >= 3{
                    bestScores.append(sortedScores[2])
                }
                
                self.bestGames = bestScores
                
                print("best Games updated")
                
                
                
                if let bestCombo = gameData.achievements.map({ $0.combo }).max() {
                    self.bestCombo = bestCombo
                }
                
            }
        }
        completion()
    }
    
    func saveScores(completion: @escaping () -> Void) {
        
        
        Task { @MainActor in
            let context = GameData.shared.sharedModelContainer.mainContext
            let gameDataDescriptor = FetchDescriptor<GameDataModel>()
            
            
            if let gameData = try context.fetch(gameDataDescriptor).first {
                
                
                if currentScore != -500{
                    gameData.achievements.append(AchievementModel(score: currentScore, combo: currentCombo, name: name))
                }
                
                
                //gameData.achievements = gameData.achievements.filter { $0.score == bestScore ||  $0.score == currentScore || $0.combo == bestCombo}
                
                
                
                
                try context.save()
            }

                

            
        }
        completion()
        
    }
    
}

