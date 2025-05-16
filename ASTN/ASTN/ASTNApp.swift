//
//  ASTNApp.swift
//  ASTN
//
//  Created by Joel Myers on 4/29/25.
//

import SwiftUI

@main
struct ASTNApp: App {
    // Initialize any app-level services or state here if needed
    init() {
        // Configure navigation bar appearance to prevent color changes during scrolling
        UINavigationBar.configureAppearance()
        
        // You can add any additional app initialization code here
        // Setup appearance, analytics, etc.
    }
    
    var body: some Scene {
        WindowGroup {
            // Start with SplashScreenView, but enable navigation replacement via AppCoordinator
            SplashScreenView()
                .onAppear {
                    // Initialize the AppCoordinator (ensures singleton is created)
                    _ = AppCoordinator.shared
                }
        }
    }
}
