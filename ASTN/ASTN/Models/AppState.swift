import Foundation
import SwiftUI
import Combine

/// A singleton class for managing app-wide state
class AppState: ObservableObject {
    // MARK: - Singleton Pattern
    static let shared = AppState()
    
    // MARK: - Published Properties 
    @Published var selectedTabIndex: Int = 0
    @Published var isAuthenticated: Bool = false
    @Published var showOnboarding: Bool = false
    @Published var activeWorkout: String? = nil
    
    // MARK: - Navigation Methods
    
    /// Navigate to a specific tab by name
    func navigateToTab(_ tabName: String) {
        switch tabName.lowercased() {
        case "dashboard", "home":
            selectedTabIndex = 0
        case "challenges":
            selectedTabIndex = 1
        case "reps":
            selectedTabIndex = 2
        case "ownership":
            selectedTabIndex = 3
        case "profile":
            selectedTabIndex = 4
        default:
            selectedTabIndex = 0
        }
    }
    
    /// Navigate to a specific tab by index
    func navigateToTabIndex(_ index: Int) {
        guard index >= 0 && index <= 4 else { return }
        selectedTabIndex = index
    }
    
    /// Navigate to a specific workout
    func navigateToWorkout(_ workoutName: String) {
        // First navigate to the Reps tab
        navigateToTab("reps")
        
        // Then set the active workout
        activeWorkout = workoutName
    }
    
    // MARK: - Authentication Methods
    
    /// Set the authentication state
    func setAuthenticated(_ authenticated: Bool, showOnboarding: Bool = false) {
        isAuthenticated = authenticated
        self.showOnboarding = showOnboarding
    }
    
    // MARK: - Init
    
    private init() {
        // Private initializer for singleton
    }
}
