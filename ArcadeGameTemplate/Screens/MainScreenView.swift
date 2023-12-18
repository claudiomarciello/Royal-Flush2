//
//  MainScreen.swift
//  ArcadeGameTemplate
//

import SwiftUI

/**
 * # MainScreenView
 *
 *   This view is responsible for presenting the game name, the game intructions and to start the game.
 *  - Customize it as much as you want.
 *  - Experiment with colors and effects on the interface
 *  - Adapt the "Insert a Coin Button" to the visual identity of your game
 **/

struct MainScreenView: View {
    @Environment(\.colorScheme) var colorScheme
    var gameLogic: ArcadeGameLogic = ArcadeGameLogic.shared

    
    @State private var playerName: String = "Player 1"


    // The game state is used to transition between the different states of the game
    @Binding var currentGameState: GameState
    
    // Change it on the Constants.swift file
    var gameTitle: String = MainScreenProperties.gameTitle
    
    // Change it on the Constants.swift file
    var gameInstructions: [Instruction] = MainScreenProperties.gameInstructions
    
    // Change it on the Constants.swift file
    let accentColor: Color = MainScreenProperties.accentColor
    
    var body: some View {

        
       ZStack {
            //added the background to the mainscreen
           Image(colorScheme == .dark ? "BackgroundDark" : "BackgroundLight")
               .resizable()
               .scaledToFill()
               .ignoresSafeArea()
            
            VStack(alignment: .center, spacing: 16.0) {
                
                /**
                 * # PRO TIP!
                 * The game title can be customized to represent the visual identity of the game
                 */
                Text("\(self.gameTitle)")
                    .font(Font.custom("PressStart2P-Regular", size: 32))
                    .fontWeight(.black)
                    .foregroundColor(Color.black)
                    .padding(.top, 40.0)
                
                Spacer()
                
                /**
                 * To customize the instructions, check the **Constants.swift** file
                 */
                ForEach(self.gameInstructions, id: \.title) { instruction in
                    GroupBox(label: Label("\(instruction.title)", systemImage: "\(instruction.icon)").foregroundColor(self.accentColor)){
                        HStack {
                            Text("\(instruction.description)")
                                .font(.callout)
                            Spacer()
                        }
                    }
                    .border(Color.accentColor, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
                }
                Spacer()
                VStack{
                    Text("Enter your name:")
                        .font(Font.custom("PressStart2P-Regular", size: 18))
                        .fontWeight(.black)
                        .foregroundColor(Color.black)
                    TextField("\(playerName)", text: $playerName)
                                            .font(Font.custom("PressStart2P-Regular", size: 18))
                                            .foregroundStyle(.black)
                                            .padding(.leading, 100)
                                            .cornerRadius(8)
                }                        .padding(.bottom, 60.0)
                    .onChange(of: playerName) { newValue in
                        // Limit the text to 6 characters
                        if playerName.count > 9 {
                            playerName = String(playerName.prefix(9))
                        }
                        
                    }
                    .onSubmit {
                        while playerName.count<9{
                            playerName += " "
                        }
                    }

                
                
                /**
                 * Customize the appearance of the **Insert a Coin** button to match the visual identity of your game
                 */
                Button {
                    withAnimation { self.startGame()
                        gameLogic.InsertName(name: playerName)
}
                } label: {
                    Text("Go!")
                        .fontWeight(.heavy)
                        .padding()
                        .frame(maxWidth: .infinity)
                }
                .foregroundColor(.white)
                .background(self.accentColor)
                .cornerRadius(10.0)
                .padding()
                .padding(.bottom, 16)

                
            }
            .padding()
            .statusBar(hidden: true)
            
        }
    }
    /**
     * Function responsible to start the game.
     * It changes the current game state to present the view which houses the game scene.
     */
    private func startGame() {
        print("- Starting the game...")
        self.currentGameState = .playing
    }
}

#Preview {
    MainScreenView(currentGameState: .constant(GameState.mainScreen))
}
