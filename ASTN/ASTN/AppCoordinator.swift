import SwiftUI
import UIKit

// Coordinator to manage app-level navigation
class AppCoordinator {
    static let shared = AppCoordinator()
    
    // MARK: - Navigation Flow
    
    // Switch from splash screen to welcome screen
    func switchToWelcomeScreen() {
        print("AppCoordinator: Switching to welcome screen")
        let welcomeView = WelcomeScreenView()
        let hostingController = UIHostingController(rootView: welcomeView)
        hostingController.modalPresentationStyle = .fullScreen
        
        // Ensure we're on the main thread when setting the root view controller
        DispatchQueue.main.async { [weak self] in
            self?.setRootViewController(hostingController)
        }
    }
    
    // Switch to login screen
    func switchToAuthFlow() {
        print("AppCoordinator: Switching to login screen")
        let loginView = LoginScreenView()
        let hostingController = UIHostingController(rootView: loginView)
        hostingController.modalPresentationStyle = .fullScreen
        
        // Ensure we're on the main thread when setting the root view controller
        DispatchQueue.main.async { [weak self] in
            self?.setRootViewController(hostingController)
        }
    }
    
    // Switch to onboarding flow after signup
    func switchToOnboardingFlow() {
        print("AppCoordinator: Switching to onboarding flow")
        let onboardingView = OnboardingView()
        let hostingController = UIHostingController(rootView: onboardingView)
        hostingController.modalPresentationStyle = .fullScreen
        
        DispatchQueue.main.async { [weak self] in
            self?.setRootViewController(hostingController)
        }
    }
    
    // Handle forgot password flow
    func showForgotPasswordFlow() {
        // This would display a forgot password screen when implemented
        // For now, we'll just print a message as a placeholder
        print("AppCoordinator: Forgot password flow would be shown here")
    }
    
    // Switch to the main tab controller, replacing entire navigation stack
    func switchToMainInterface() {
        print("AppCoordinator: Switching to main interface")
        let mainTabView = MainTabView()
        let hostingController = UIHostingController(rootView: mainTabView)
        hostingController.modalPresentationStyle = .fullScreen
        
        DispatchQueue.main.async { [weak self] in
            self?.setRootViewController(hostingController)
        }
    }
    
    // MARK: - Helper Methods
    
    // Helper method to set the root view controller with animation
    private func setRootViewController(_ viewController: UIViewController) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first(where: { $0.isKeyWindow }) else {
            print("AppCoordinator: Could not find key window")
            return
        }
        
        // Print debug info to verify window exists
        print("AppCoordinator: Setting root view controller to \(type(of: viewController))")
        
        // Optional animation for smoother transition
        UIView.transition(with: window, 
                          duration: 0.3, 
                          options: .transitionCrossDissolve, 
                          animations: {
            window.rootViewController = viewController
        }, completion: { _ in
            print("AppCoordinator: Root view controller transition completed")
        })
    }
}
