import SwiftUI
import UIKit
import Combine

struct SettingsView: View {
    @Binding var isPresented: Bool
    
    // Access the app state and user session
    @EnvironmentObject var appState: AppState
    @State private var showLogoutConfirmation = false
    
    // Function to perform logout
    private func performLogout() {
        // Dismiss the settings modal
        isPresented = false
        
        // Clear user session data
        UserSession.shared.logout()
        
        // Reset any app state as needed
        appState.selectedTabIndex = 0
        appState.activeWorkout = nil
        
        // Use AppCoordinator to navigate back to the welcome screen
        // This ensures proper view hierarchy and environment objects
        DispatchQueue.main.async {
            AppCoordinator.shared.switchToWelcomeScreen()
        }
    }
    
    var body: some View {
        // Semi-transparent background overlay
        ZStack {
            // Background dimmer
            Color.black.opacity(0.3)
                .edgesIgnoringSafeArea(.all)
            
            // Modal content container
            VStack(spacing: 0) {
                // Close button at top right
                HStack {
                    Spacer()
                    Button(action: {
                        isPresented = false
                    }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.white)
                            .padding(16)
                    }
                }
                
                // Title
                Text("Settings")
                    .font(.custom("Magistral", size: 24))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.bottom, 8)
                
                // Subtitle
                Text("Manage your profile settings and preferences")
                    .font(.custom("Magistral", size: 16))
                    .foregroundColor(.white.opacity(0.6))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 32)
                
                // Settings rows
                VStack(spacing: 16) {
                    SettingsRowView(
                        icon: nil,
                        title: "Notifications",
                        subtitle: "Manage app notifications",
                        actionType: .navigate
                    )
                    
                    SettingsRowView(
                        icon: nil,
                        title: "Account",
                        subtitle: "Manage account details",
                        actionType: .navigate
                    )
                    
                    SettingsRowView(
                        icon: nil,
                        title: "Privacy",
                        subtitle: "Control your data",
                        actionType: .navigate
                    )
                    
                    SettingsRowView(
                        icon: nil,
                        title: "Add Advisor",
                        subtitle: "Add parent, advisor, agent, etc.",
                        actionType: .add,
                        tintColor: Color(red: 0.0, green: 0.478, blue: 1.0) // iOS branded blue
                    )
                }
                .padding(.horizontal, 20)
                
                Spacer()
                
                // Logout button
                Button(action: {
                    // Show confirmation dialog before logging out
                    showLogoutConfirmation = true
                }) {
                    Text("Logout")
                        .font(.custom("Magistral", size: 16))
                        .fontWeight(.medium)
                        .foregroundColor(.red)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.white)
                        .cornerRadius(8)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 24)
                .alert("Logout", isPresented: $showLogoutConfirmation) {
                    Button("Cancel", role: .cancel) { }
                    Button("Logout", role: .destructive) {
                        performLogout()
                    }
                } message: {
                    Text("Are you sure you want to log out?")
                }
            }
            .frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height * 0.6)
            .background(Color.black)
            .cornerRadius(20)
            .shadow(radius: 20)
        }
        .edgesIgnoringSafeArea(.all)
    }
}

// Reusable settings row component
struct SettingsRowView: View {
    enum ActionType {
        case navigate, add, toggle
    }
    
    let icon: String?
    let title: String
    let subtitle: String
    let actionType: ActionType
    var tintColor: Color = .white
    
    var body: some View {
        Button(action: {
            // Navigation action would go here
        }) {
            HStack {
                if let icon = icon {
                    Image(systemName: icon)
                        .foregroundColor(tintColor)
                        .frame(width: 24, height: 24)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.custom("Magistral", size: 18))
                        .foregroundColor(tintColor)
                    
                    Text(subtitle)
                        .font(.custom("Magistral", size: 14))
                        .foregroundColor(.white.opacity(0.6))
                }
                
                Spacer()
                
                // Action indicator (arrow or plus icon)
                switch actionType {
                case .navigate:
                    Image(systemName: "chevron.right")
                        .foregroundColor(.white.opacity(0.6))
                        .font(.system(size: 14))
                case .add:
                    Image(systemName: "plus")
                        .foregroundColor(tintColor)
                        .font(.system(size: 14))
                case .toggle:
                    // Could add a toggle switch here
                    EmptyView()
                }
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 20)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// Preview

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(isPresented: .constant(true))
            .environmentObject(AppState.shared)
            .preferredColorScheme(.dark)
    }
}
