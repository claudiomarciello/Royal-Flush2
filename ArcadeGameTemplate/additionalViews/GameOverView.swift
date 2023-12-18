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
    @Environment(\.colorScheme) var colorScheme

    @Binding var currentGameState: GameState
    
    var body: some View {
        ZStack {
            Image(colorScheme == .dark ? "BackgroundDark" : "BackgroundLight")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            VStack(alignment: .center) {
                let state = ArcadeGameLogic.shared
                let currentScore = state.currentScore
                let lastScore = state.lastScore
                let combo = state.currentCombo
                let bestScore = state.bestScore
                let bestCombo = state.bestCombo
                
                

                
                if currentScore > bestScore {
                    
                    Text("New record!")
                        .font(Font.custom("PressStart2P-Regular", size: 24))
                        .foregroundStyle(.black)                        .padding(.top, 80)

                    Text("Score: \(currentScore)")
                        .font(Font.custom("PressStart2P-Regular", size: 32))
                        .fontWeight(.bold)
                        .foregroundStyle(.black)
                        .padding(.bottom, 80)

                } else {
                    Text("Score: \(currentScore)")
                        .font(Font.custom("PressStart2P-Regular", size: 32))
                        .foregroundStyle(.black)
                        .padding(.bottom,5)
                        .padding(.top, 80)

                    
                    Text("Score Record: \(bestScore)")
                        .font(Font.custom("PressStart2P-Regular", size: 18))
                        .foregroundStyle(.black)
                        .padding(.bottom, 80)

                }
                



                
                
                if combo > bestCombo {
                    
                    Text("New record!")
                        .font(Font.custom("PressStart2P-Regular", size: 24))
                        .foregroundStyle(.black)
                    Text("Combo: x\(combo)")
                        .font(Font.custom("PressStart2P-Regular", size: 32))
                        .fontWeight(.bold)
                        .foregroundStyle(.black)

                } else {
                    Text("Combo: x\(combo)")
                        .font(Font.custom("PressStart2P-Regular", size: 24))
                        .foregroundStyle(.black)
                        .padding(.bottom,5)

                    Text("Combo Record: x\(bestCombo)")
                        .font(Font.custom("PressStart2P-Regular", size: 18))
                        .foregroundStyle(.black)
                        .padding(.bottom, 50)
                }
                


                
                

                Spacer()
                    
            }
            .padding(.bottom, 310)
            
                HStack(spacing: 100) {
                    Button {
                        withAnimation { self.backToMainScreen() }
                    } label: {
                        Image(systemName: "arrow.backward")
                            .foregroundColor(.primary)
                            .font(.title)
                    }
                    .background(Circle().foregroundColor(Color(uiColor: UIColor.systemGray6)).frame(width: 100, height: 100, alignment: .center))
                    
                    Button {
                        withAnimation { self.restartGame() }
                    } label: {
                        Image(systemName: "arrow.clockwise")
                           .foregroundColor(.primary)
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
