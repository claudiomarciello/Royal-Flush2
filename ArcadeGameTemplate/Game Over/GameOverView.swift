//
//  GameOverView.swift
//  ArcadeGameTemplate
//

import SwiftUI

/**
 * # GameOverView
 *   This view is responsible for showing the game over state of the game.
 *  Currently it only present buttons to take the player back to the main screen or restart the game.
 *
 *  You can also present score of the player, present any kind of achievements or rewards the player
 *  might have accomplished during the game session, etc...
 **/

struct GameOverView: View {
    
    @Binding var currentGameState: GameState
    
    var body: some View {
        ZStack {
            Image("BackgroundBlueGradient")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            VStack(alignment: .center) {
                let state = ArcadeGameLogic.shared
                let currentScore = state.currentScore
                let lastScore = state.lastScore
                
                if currentScore > lastScore {
                    Spacer()
                    Text("\(currentScore)")
                        .font(Font.custom("AmericanTypewriter-Bold", size: 68))
                        .fontWeight(.bold)
                    Text("new record!")
                        .font(Font.custom("AmericanTypewriter-Bold", size: 24))
                } else {
                    Spacer()
                    Text("\(currentScore)")
                        .font(Font.custom("AmericanTypewriter-Bold", size: 68))
                        .fontWeight(.bold)
                    Text("your current score")
                        .font(Font.custom("AmericanTypewriter-Bold", size: 24))
                    
                    Text("\(lastScore)")
                        .font(Font.custom("AmericanTypewriter-Bold", size: 24))
                        .padding(.vertical, 8)
                    Text("your last score")
                        .font(Font.custom("AmericanTypewriter-Bold", size: 18))
                }
            
                Spacer()
                
                // Display Player's Score
                Text("Score: 1500")
                    .font(.headline)
                    .foregroundColor(.black)
                
                // Display Player's Combo
                Text("Combo: 300")
                    .font(.headline)
                    .foregroundColor(.black)
                    .padding()
                
                
                Spacer()
                    
            }
            .padding(.bottom, 310)
            
                HStack(spacing: 100) {
                    Button {
                        withAnimation { self.backToMainScreen() }
                    } label: {
                        Image(systemName: "arrow.backward")
                            .foregroundColor(.black)
                            .font(.title)
                    }
                    .background(Circle().foregroundColor(Color(uiColor: UIColor.systemGray6)).frame(width: 100, height: 100, alignment: .center))
                    
                    Button {
                        withAnimation { self.restartGame() }
                    } label: {
                        Image(systemName: "arrow.clockwise")
                            .foregroundColor(.black)
                            .font(.title)
                    }
                    .background(Circle().foregroundColor(Color(uiColor: UIColor.systemGray6)).frame(width: 100, height: 100, alignment: .center))
                }
                
                
                .padding(.top, 400)
            
        }
        .statusBar(hidden: true)
    }
     
    private func backToMainScreen() {
        self.currentGameState = .mainScreen
    }
    
    private func restartGame() {
        self.currentGameState = .playing
    }
}

#Preview {
    GameOverView(currentGameState: .constant(GameState.gameOver))
}
