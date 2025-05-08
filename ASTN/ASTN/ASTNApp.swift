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
        // You can add any app initialization code here
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
