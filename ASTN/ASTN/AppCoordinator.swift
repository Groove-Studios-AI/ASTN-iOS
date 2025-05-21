import SwiftUI
import UIKit
import Combine

// Extension to apply all required environment objects to any view
extension View {
    /// Apply all shared environment objects required by the app
    func withSharedEnvironment() -> some View {
        self
            .environmentObject(AppState.shared)
            .preferredColorScheme(.dark)
    }
}

// Coordinator to manage app-level navigation
class AppCoordinator {
    static let shared = AppCoordinator()
    
    // MARK: - Navigation Flow
    
    // Switch from splash screen to welcome screen
    func switchToWelcomeScreen() {
        print("AppCoordinator: Switching to welcome screen")
        // Use the shared environment modifier
        let welcomeView = WelcomeScreenView().withSharedEnvironment()
        
        presentView(welcomeView)
    }
    
    // Switch to login screen
    func switchToAuthFlow() {
        print("AppCoordinator: Switching to login screen")
        // Use the shared environment modifier
        let loginView = LoginScreenView().withSharedEnvironment()
        
        presentView(loginView)
    }
    
    // Specific method for logout - Switch to login screen
    func switchToLoginFlow() {
        print("AppCoordinator: Switching to login screen after logout")
        // Use the shared environment modifier
        let loginView = LoginScreenView().withSharedEnvironment()
        
        presentView(loginView)
    }
    
    // Switch to onboarding flow after signup
    func switchToOnboardingFlow() {
        print("AppCoordinator: Switching to onboarding flow")
        // Use the shared environment modifier
        let onboardingView = OnboardingView().withSharedEnvironment()
        
        presentView(onboardingView)
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
        // Use the shared environment modifier
        let mainTabView = MainTabView().withSharedEnvironment()
        
        presentView(mainTabView)
    }
    
    // MARK: - Helper Methods
    
    /// A generic method to present any SwiftUI view as the root view controller with proper environment
    private func presentView<Content: View>(_ content: Content) {
        let hostingController = UIHostingController(rootView: content)
        hostingController.modalPresentationStyle = .fullScreen
        
        // Apply dark theme to the hosting controller view
        hostingController.view.backgroundColor = .black
        
        // Ensure we're on the main thread when setting the root view controller
        DispatchQueue.main.async { [weak self] in
            self?.setRootViewController(hostingController)
        }
    }
    
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
