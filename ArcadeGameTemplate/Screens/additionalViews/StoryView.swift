//
//  StoryView.swift
//  Royal Flush
//
//  Created by Katharina Brutscher on 15/12/23.
//

import SwiftUI

struct StoryView: View {
    
    @Environment(\.colorScheme) var colorScheme

    @Binding var isPresented: Bool
    
    @State private var scale = CGSize(width: 0.8, height: 0.8)
    @State private var systemImageOpacity = 0.0
    @State private var imageOpacity = 1.0
    @State private var opacity = 1.0
    let frameCount = 10 // frames need to be named from name0.png to name95.png
    
    @State private var currentFrame: Int = 0
    
    var body: some View {
        ZStack{
            //Image("BackgroundLight").ignoresSafeArea().aspectRatio(contentMode: .fill)
            VStack {
                
                Text("Oh No!!! The Princess got stolen by a Toilet!")
                    .font(Font.custom("PressStart2P-Regular", size: 28))
                    //.fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(colorScheme == .dark ? Color.white : Color.black)
                    .padding(.vertical, 50)
                Spacer()
                Spacer()
                Image("story\(currentFrame)")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .offset(y:15)
                // .frame(width: geometry.size.width, height: geometry.size.height)
                    .onAppear {
                        // Create a timer for the animation loop
                        Timer.scheduledTimer(withTimeInterval: 1.0 / 5.0, repeats: true) { timer in
                            currentFrame = (currentFrame + 1) % frameCount
                        }
                    }
                
               
            }
            .padding()
            .opacity(opacity)
            .onAppear{
                withAnimation(.easeInOut(duration: 1.5)){
                    scale = CGSize(width: 1, height: 1)
                    systemImageOpacity = 1
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: {
                    withAnimation(.easeIn(duration: 0.35)){
                        opacity = 0
                    }
                })
                
                // This DQMaA will take the user to the main page.
                DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: {
                    withAnimation(.easeIn(duration: 0.2)){
                        isPresented.toggle()
                    }
                })
            }}
    }
}

#Preview {
    StoryView(isPresented: .constant(true))
}
