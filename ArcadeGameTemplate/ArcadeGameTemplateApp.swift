//
//  ArcadeGameTemplateApp.swift
//  ArcadeGameTemplate
//

import SwiftUI
import SwiftData

@main
struct ArcadeGameTemplateApp: App {
    @State var isSplashScreenPresented: Bool = true

    var body: some Scene {
        WindowGroup {
            if !isSplashScreenPresented{
                
                ContentView()}
            
            else
            {
                StoryView(isPresented: $isSplashScreenPresented)
            }
            
        }}
}
