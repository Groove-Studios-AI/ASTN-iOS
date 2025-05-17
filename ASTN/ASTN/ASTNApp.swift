//
//  ASTNApp.swift
//  ASTN
//
//  Created by Joel Myers on 4/29/25.
//

import SwiftUI
import CoreData

@main
struct ASTNApp: App {
    // Initialize the PersistenceController
    let persistenceController = PersistenceController.shared

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
                .environment(\.managedObjectContext, persistenceController.container.viewContext) // Inject context
                .onAppear {
                    // Initialize the AppCoordinator (ensures singleton is created)
                    _ = AppCoordinator.shared
                }
        }
    }
}
