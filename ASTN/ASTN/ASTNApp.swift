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
    
    // Configure the UINavigationBar appearance to prevent color changes during scrolling
    private func configureNavigationBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(named: "NavBarBackground") ?? .systemBackground
        
        // Title text attributes
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor(named: "NavBarText") ?? .label
        ]
        
        // Setup for all navigation bars
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        
        // Ensure the tint color is set properly for bar button items
        UINavigationBar.appearance().tintColor = UIColor(named: "AccentColor") ?? .systemBlue
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
        }
    }
}
