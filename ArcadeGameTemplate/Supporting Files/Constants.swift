//
//  Constants.swift
//  ArcadeGameTemplate
//

import Foundation
import SwiftUI

/**
 * # Constants
 *
 * This file gathers contant values that are shared all around the project.
 * Modifying the values of these constants will reflect along the complete interface of the application.
 *
 **/


/**
 * # GameState
 * Defines the different states of the game.
 * Used for supporting the navigation in the project template.
 */

enum GameState {
    case mainScreen
    case playing
    case gameOver
}

typealias Instruction = (icon: String, title: String, description: String)

/**
 * # MainScreenProperties
 *
 * Keeps the information that shows up on the main screen of the game.
 *
 */

struct MainScreenProperties {
    static let gameTitle: String = "Royal Flush"
    
    static let gameInstructions: [Instruction] = [
        (icon: "hand.tap", title: "Tap to Jump, Drag to Move", description: "Tap on the screen to jump the Toilets. Drag to move left and right."),
        (icon: "flag.circle", title: "Close Toilets", description: "Close all the Toilets on your way to the Princess."),
        (icon: "multiply.circle", title: "Make sure to leave no open Toilets", description: "If you fall you lose!")
    ]
    
    /**
     * To change the Accent Color of the applciation edit it on the Assets folder.
     */
    
    static let accentColor: Color = Color.accentColor
}
