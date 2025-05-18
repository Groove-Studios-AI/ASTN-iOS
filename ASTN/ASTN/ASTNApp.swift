//
//  ASTNApp.swift
//  ASTN
//
//  Created by Joel Myers on 4/29/25.
//

import SwiftUI
import Combine
import UIKit

@main
struct ASTNApp: App {
    // Initialize app-level services and state
    @StateObject private var appState = AppState.shared
    
    init() {
        // Configure navigation bar appearance to prevent color changes during scrolling
        configureNavigationBarAppearance()
        
        // You can add any additional app initialization code here
        // Setup appearance, analytics, etc.
    }
    
    // Configure the UINavigationBar appearance with dark theme
    private func configureNavigationBarAppearance() {
        // Create and configure appearance
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        
        // Set background to black
        appearance.backgroundColor = .black
        
        // Set title text color to white
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
        
        // Set large title attributes if used
        appearance.largeTitleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
        
        // Apply appearance settings to all navigation bar states
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        
        // Set tint color for bar button items to white
        UINavigationBar.appearance().tintColor = .white
        
        // Note: For status bar style, we need to set View.preferredColorScheme(.dark)
        // or configure in Info.plist with UIUserInterfaceStyle = Dark
    }
    
    var body: some Scene {
        WindowGroup {
            // Start with SplashScreenView, but enable navigation replacement via AppCoordinator
            SplashScreenView()
                .environmentObject(appState)
                .onAppear {
                    // Initialize the AppCoordinator (ensures singleton is created)
                    _ = AppCoordinator.shared
                }
                // Apply dark mode to the entire app
                .preferredColorScheme(.dark)
        }
    }
}
