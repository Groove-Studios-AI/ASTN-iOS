import SwiftUI

// Import game preview screens
import UIKit

struct OnboardingView: View {
    @ObservedObject private var userSession = UserSession.shared
    @State private var currentStep = 1
    // Total steps increased to 8 to include game preview screens
    @State private var totalSteps = 8
    
    // Onboarding navigation state
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.fromHex("#0A0A0A").ignoresSafeArea() // Black background
                
                VStack {
                    // Content based on current step
                    Group {
                        switch currentStep {
                        case 1:
                            OnboardingStep1View(
                                onContinue: { athleteType, sport, dateOfBirth, phoneNumber in
                                    // Check and log user existence state
                                    if let user = userSession.currentUser {
                                        print("✅ User object available: \(user.id), email: \(user.email)")
                                    } else {
                                        print("⚠️ User object is nil. Creating a temporary user...")
                                        // This is a fallback approach - create a temporary user if none exists
                                        // In production, we should diagnose why the user isn't properly available
                                        userSession.createTemporaryUserIfNeeded()
                                    }
                                    
                                    // Update user with step 1 data
                                    userSession.updateUserStep1(athleteType: athleteType, sport: sport, dateOfBirth: dateOfBirth, phoneNumber: phoneNumber) { result in
                                        switch result {
                                        case .success(let user):
                                            print("✅ Successfully updated user for step 1: \(user.id)")
                                            
                                            // Only update Cognito attributes for non-temporary users
                                            if !userSession.isTemporaryUser() {
                                                userSession.updateCognitoStep1Attributes(athleteType: athleteType, sport: sport, dateOfBirth: dateOfBirth, phoneNumber: phoneNumber) { cognitoResult in
                                                    if case .success = cognitoResult {
                                                        print("✅ Cognito attributes updated for step 1")
                                                    } else if case .failure(let error) = cognitoResult {
                                                        print("⚠️ Cognito attribute update failed: \(error)")
                                                    }
                                                }
                                            } else {
                                                print("ℹ️ Skipping Cognito update for temporary user")
                                            }
                                            
                                            // Navigate to next step
                                            withAnimation {
                                                currentStep = 2
                                            }
                                        case .failure(let error):
                                            print("❌ Error updating user: \(error)")
                                            // Even if there's an error, proceed to next step
                                            print("⚠️ Proceeding to next step despite error")
                                            withAnimation {
                                                currentStep = 2
                                            }
                                        }
                                    }
                                }
                            )
                        case 2:
                            OnboardingStep2View(
                                onContinue: { interests in
                                    // Check user object availability
                                    if userSession.currentUser == nil {
                                        print("⚠️ User object is nil before Step 2. Creating a temporary user...")
                                        userSession.createTemporaryUserIfNeeded()
                                    }
                                    
                                    // Update user with step 2 data
                                    userSession.updateUserStep2(interests: interests) { result in
                                        switch result {
                                        case .success(let user):
                                            print("✅ Successfully updated user for step 2: \(user.id)")
                                            
                                            // Only update Cognito attributes for non-temporary users
                                            if !userSession.isTemporaryUser() {
                                                userSession.updateCognitoStep2Attributes(interests: interests) { cognitoResult in
                                                    if case .success = cognitoResult {
                                                        print("✅ Cognito attributes updated for step 2")
                                                    } else if case .failure(let error) = cognitoResult {
                                                        print("⚠️ Cognito attribute update failed: \(error)")
                                                    }
                                                }
                                            } else {
                                                print("ℹ️ Skipping Cognito update for temporary user")
                                            }
                                            
                                            // Navigate to next step
                                            withAnimation {
                                                currentStep = 3
                                            }
                                        case .failure(let error):
                                            print("❌ Error updating user: \(error)")
                                            // Even if there's an error, proceed to next step
                                            print("⚠️ Proceeding to next step despite error")
                                            withAnimation {
                                                currentStep = 3
                                            }
                                        }
                                    }
                                }
                            )
                        case 3:
                            OnboardingStep3View(
                                onContinue: { learningGoal in
                                    // Check user object availability
                                    if userSession.currentUser == nil {
                                        print("⚠️ User object is nil before Step 3. Creating a temporary user...")
                                        userSession.createTemporaryUserIfNeeded()
                                    }
                                    
                                    // Update user with step 3 data
                                    userSession.updateUserStep3(learningGoal: learningGoal) { result in
                                        switch result {
                                        case .success(let user):
                                            print("✅ Successfully updated user for step 3: \(user.id)")
                                            
                                            // Only update Cognito attributes for non-temporary users
                                            if !userSession.isTemporaryUser() {
                                                userSession.updateCognitoStep3Attributes(learningGoal: learningGoal) { cognitoResult in
                                                    if case .success = cognitoResult {
                                                        print("✅ Cognito attributes updated for step 3")
                                                    } else if case .failure(let error) = cognitoResult {
                                                        print("⚠️ Cognito attribute update failed: \(error)")
                                                    }
                                                }
                                            } else {
                                                print("ℹ️ Skipping Cognito update for temporary user")
                                            }
                                            
                                            // Move to profile picture step
                                            withAnimation {
                                                currentStep = 4
                                            }
                                        case .failure(let error):
                                            print("❌ Error updating user: \(error)")
                                            // Even if there's an error, proceed to next step
                                            print("⚠️ Proceeding to next step despite error")
                                            withAnimation {
                                                currentStep = 4
                                            }
                                        }
                                    }
                                }
                            )
                        case 4:
                            ProfilePictureView(
                                onComplete: { profileImage in
                                    // Update user's profile picture
                                    if let user = userSession.currentUser, let image = profileImage {
                                        // In a real app, we'd upload the image to a server
                                        // and update the user's profile picture URL
                                        print("Profile picture selected, would upload to server")
                                    }
                                    // Move to game preview instead of main interface
                                    withAnimation {
                                        currentStep = 5
                                    }
                                }
                            )
                            
                        case 5:
                            // Game Preview Intro Screen
                            GamePreviewIntroView(
                                onContinue: {
                                    withAnimation {
                                        currentStep = 6
                                    }
                                }
                            )
                            
                        case 6:
                            // Game Preview Question Screen
                            GamePreviewQuestionView(
                                onContinue: {
                                    withAnimation {
                                        currentStep = 7
                                    }
                                }
                            )
                            
                        case 7:
                            // Game Preview Stats Screen
                            GamePreviewStatsView(
                                onContinue: {
                                    withAnimation {
                                        currentStep = 8
                                    }
                                }
                            )
                            
                        case 8:
                            // Game Preview Plan Screen
                            GamePreviewPlanView(
                                onComplete: {
                                    // Complete onboarding and go to main interface
                                    AppCoordinator.shared.switchToMainInterface()
                                }
                            )
                        default:
                            Text("Onboarding Complete")
                                .foregroundColor(.white)
                        }
                    }
                }
            }
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        if currentStep > 1 {
                            // Go back to previous step
                            withAnimation {
                                currentStep -= 1
                            }
                        } else {
                            // On first step, dismiss the onboarding
                            presentationMode.wrappedValue.dismiss()
                        }
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white)
                            .imageScale(.large)
                    }
                }
                
                ToolbarItem(placement: .principal) {
                    Text("Sign Up")
                        .font(.custom("Magistral", size: 22))
                        .foregroundColor(.white)
                }
            }
        }
    }
}
