//
//  StoryView.swift
//  Royal Flush
//
//  Created by Katharina Brutscher on 15/12/23.
//

import SwiftUI

struct StoryView: View {
    
    let frameCount = 10 // frames need to be named from name0.png to name95.png
    
        @State private var currentFrame: Int = 0
    
    var body: some View {
      
        VStack {
            Image("story\(currentFrame)")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .offset(y:-30)
            // .frame(width: geometry.size.width, height: geometry.size.height)
                .onAppear {
                    // Create a timer for the animation loop
                    Timer.scheduledTimer(withTimeInterval: 1.0 / 5.0, repeats: true) { timer in
                        currentFrame = (currentFrame + 1) % frameCount
                    }
                }
            
            Text("Oh No!!! The Princess got stolen by a Toilet!")
                .font(Font.custom("PressStart2P-Regular", size: 20))
                .fontWeight(.bold)
                .foregroundStyle(.black)
        }
        .padding()
    }
        
    
    
}

#Preview {
    StoryView()
}
