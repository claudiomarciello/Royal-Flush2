//
//  StoryView.swift
//  Royal Flush
//
//  Created by Katharina Brutscher on 15/12/23.
//

import SwiftUI

struct StoryView: View {
    
    @Binding var isPresented: Bool
    
    @State private var scale = CGSize(width: 0.8, height: 0.8)
    @State private var systemImageOpacity = 0.0
    @State private var imageOpacity = 1.0
    @State private var opacity = 1.0
    let frameCount = 10 // frames need to be named from name0.png to name95.png
    
        @State private var currentFrame: Int = 0
    
    var body: some View {
        ZStack{
            Image("BackgroundLight").ignoresSafeArea().aspectRatio(contentMode: .fill)
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
            .opacity(opacity)
            .onAppear{
                withAnimation(.easeInOut(duration: 1.5)){
                    scale = CGSize(width: 1, height: 1)
                    systemImageOpacity = 1
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5, execute: {
                    withAnimation(.easeIn(duration: 0.35)){
                        opacity = 0
                    }
                })
                
                // This DQMaA will take the user to the main page.
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.8, execute: {
                    withAnimation(.easeIn(duration: 0.2)){
                        isPresented.toggle()
                    }
                })
            }}
    }
}

#Preview {
    SplashView(isPresented: .constant(true))
}
