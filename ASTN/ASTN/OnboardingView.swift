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
                                    // Update user with step 1 data
                                    if userSession.currentUser != nil {
                                        userSession.updateUserStep1(athleteType: athleteType, sport: sport, dateOfBirth: dateOfBirth, phoneNumber: phoneNumber) { result in
                                            switch result {
                                            case .success(_):
                                                // Navigate to next step
                                                withAnimation {
                                                    currentStep = 2
                                                }
                                            case .failure(let error):
                                                print("Error updating user: \(error)")
                                                // Handle error display
                                            }
                                        }
                                    }
                                }
                            )
                        case 2:
                            OnboardingStep2View(
                                onContinue: { interests in
                                    // Update user with step 2 data
                                    if userSession.currentUser != nil {
                                        userSession.updateUserStep2(interests: interests) { result in
                                            switch result {
                                            case .success(_):
                                                // Navigate to next step
                                                withAnimation {
                                                    currentStep = 3
                                                }
                                            case .failure(let error):
                                                print("Error updating user: \(error)")
                                                // Handle error display
                                            }
                                        }
                                    }
                                }
                            )
                        case 3:
                            OnboardingStep3View(
                                onContinue: { learningGoal in
                                    // Update user with step 3 data
                                    if userSession.currentUser != nil {
                                        userSession.updateUserStep3(learningGoal: learningGoal) { result in
                                            switch result {
                                            case .success(_):
                                                // Move to profile picture step
                                                withAnimation {
                                                    currentStep = 4
                                                }
                                            case .failure(let error):
                                                print("Error updating user: \(error)")
                                                // Even if there's an error, proceed to next step
                                                withAnimation {
                                                    currentStep = 4
                                                }
                                            }
                                        }
                                    } else {
                                        // Handle case when user is nil (for testing)
                                        withAnimation {
                                            currentStep = 4
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
