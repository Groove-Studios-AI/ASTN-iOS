import SwiftUI
import UIKit

// Coordinator to manage app-level navigation
class AppCoordinator {
    static let shared = AppCoordinator()
    
    // MARK: - Navigation Flow
    
    // Switch from splash screen to welcome screen
    func switchToWelcomeScreen() {
        let welcomeView = WelcomeScreenView()
        let hostingController = UIHostingController(rootView: welcomeView)
        
        setRootViewController(hostingController)
    }
    
    // Switch to login screen
    func switchToAuthFlow() {
        let loginView = LoginScreenView()
        let hostingController = UIHostingController(rootView: loginView)
        
        setRootViewController(hostingController)
    }
    
    // Handle forgot password flow
    func showForgotPasswordFlow() {
        // This would display a forgot password screen when implemented
        // For now, we'll just print a message as a placeholder
        print("Forgot password flow would be shown here")
    }
    
    // Switch to the main tab controller, replacing entire navigation stack
    func switchToMainInterface() {
        let mainTabView = MainTabView()
        let hostingController = UIHostingController(rootView: mainTabView)
        
        setRootViewController(hostingController)
    }
    
    // MARK: - Helper Methods
    
    // Helper method to set the root view controller with animation
    private func setRootViewController(_ viewController: UIViewController) {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            
            // Optional animation for smoother transition
            UIView.transition(with: window, 
                              duration: 0.3, 
                              options: .transitionCrossDissolve, 
                              animations: {
                window.rootViewController = viewController
            }, completion: nil)
        }
    }
}
