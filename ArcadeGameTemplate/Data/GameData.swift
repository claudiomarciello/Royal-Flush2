//
//  GameData.swift
//  Royal Flush
//
//  Created by Alexandr Chubutkin on 12/12/23.
//

import Foundation
import SwiftData

class GameData {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            GameDataModel.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)

        do {
            let container = try ModelContainer(for: schema, configurations: [modelConfiguration])
            
            Task { @MainActor in
                let context = container.mainContext
                let gameDataDescriptor = FetchDescriptor<GameDataModel>()
                
                var gameData = try context.fetch(gameDataDescriptor).first
                if gameData == nil {
                    gameData = GameDataModel(achievements: [])
                    context.insert(gameData!)
                }
                
                try context.save()
            }
            
            return container
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    static let shared: GameData = GameData()
}
