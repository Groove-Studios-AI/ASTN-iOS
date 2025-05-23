//
//  SplashScreenView.swift
//  ASTN
//
//  Created by Joel Myers on 5/2/25.
//

import SwiftUI
import UIKit
import Amplify
import Combine

struct SplashScreenView: View {
    // Access UserSession to check auth state
    @ObservedObject private var userSession = UserSession.shared
    
    @State private var isActive = false
    @State private var opacity = 0.5
    @State private var scale: CGFloat = 0.8
    @State private var isCheckingSession = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                
                VStack {
                    Spacer()
                    
                    Image("ASTN_LaunchLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 180, height: 180)
                        .opacity(opacity)
                        .scaleEffect(scale)
                    
//                    Text("ASTN")
//                        .font(.system(size: 42, weight: .bold))
//                        .foregroundColor(.white)
//                        .padding(.top, 20)
//                        .opacity(opacity)
//                        .scaleEffect(scale)
                    
                    Spacer()
                    
                    Text("Version 1.0")
                        .font(.system(size: 16))
                        .foregroundColor(.gray)
                        .padding(.bottom, 20)
                        .opacity(opacity)
                }
            }
            .onAppear {
                // Animate the logo and text appearance
                withAnimation(.easeIn(duration: 1.2)) {
                    self.opacity = 1.0
                    self.scale = 1.0
                }
                
                // Check for existing authenticated session
                checkAuthSession()
            }
        }
    }
    
    // Check if user is already authenticated and navigate appropriately
    private func checkAuthSession() {
        guard !isCheckingSession else { return }
        isCheckingSession = true
        
        Task {
            do {
                // Check Amplify auth session
                let session = try await Amplify.Auth.fetchAuthSession()
                
                if session.isSignedIn {
                    // User is already signed in
                    print("✅ SplashScreen: Found existing authenticated session")
                    
                    // Restore user data
                    await userSession.restoreUserSession()
                    
                    // Set dashboard as the selected tab
                    await MainActor.run {
                        AppState.shared.selectedTabIndex = 0 // Dashboard tab
                    }
                    
                    // Switch to main interface after animation completes
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        print("✅ SplashScreen: Auto-login successful, going to dashboard")
                        AppCoordinator.shared.switchToMainInterface()
                    }
                } else {
                    // No existing session, go to welcome screen
                    print("ℹ️ SplashScreen: No active session found, showing welcome screen")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        AppCoordinator.shared.switchToWelcomeScreen()
                    }
                }
            } catch {
                // Error checking session, default to welcome screen
                print("⚠️ SplashScreen: Error checking auth session: \(error)")
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    AppCoordinator.shared.switchToWelcomeScreen()
                }
            }
            
            isCheckingSession = false
        }
    }
}

struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenView()
    }
}
