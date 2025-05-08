import SwiftUI
import UIKit

// Coordinator to manage app-level navigation
class AppCoordinator {
    static let shared = AppCoordinator()
    
    // Switch to the main tab controller, replacing entire navigation stack
    func switchToMainInterface() {
        let mainTabView = MainTabView()
        let hostingController = UIHostingController(rootView: mainTabView)
        
        // Set the tab controller as the root view controller
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            
            // Optional animation for smoother transition
            UIView.transition(with: window, 
                              duration: 0.3, 
                              options: .transitionCrossDissolve, 
                              animations: {
                window.rootViewController = hostingController
            }, completion: nil)
        }
    }
}
