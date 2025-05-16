import SwiftUI
import UIKit

struct OnboardingStep2View: View {
    // Callback when the user continues to the next step
    var onContinue: ([Interest]) -> Void
    
    // State for selections
    @State private var selectedInterests = Set<Interest>()
    @State private var showMaxSelectionWarning = false
    
    // Max number of interests
    private let maxInterests = 10
    
    // Form validation
    private var isFormValid: Bool {
        !selectedInterests.isEmpty
    }
    
    // All available interests for selection
    private let allInterests: [Interest] = [
        .familyAndRelationships,
        .education,
        .music,
        .technology,
        .travel,
        .healthAndWellness,
        .innovation,
        .artAndCulture,
        .commerce,
        .fitness,
        .entrepreneurship,
        .sustainability,
        .animalWelfare,
        .foodAndCooking,
        .communityEngagement,
        .adventureAndOutdoor,
        .mentalHealth,
        .gaming,
        .fashion,
        .environmentalConservation
    ]
    
    var body: some View {
        ZStack {
            // Background
            Color.black.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                
                // Progress indicator
                ZStack(alignment: .leading) {
                    // Background track
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 3)
                    
                    // Blue progress indicator
                    Rectangle()
                        .fill(Color.fromHex("#1A2196"))
                        .frame(width: UIScreen.main.bounds.width * 0.66, height: 3) // 2/3 progress
                    
                    // Position indicators
                    HStack(spacing: 0) {
                        // Step 1 indicator (complete)
                        Circle()
                            .fill(Color.fromHex("#1A2196"))
                            .frame(width: 12, height: 12)
                        
                        Spacer()
                        
                        // Step 2 indicator (current)
                        Circle()
                            .fill(Color.fromHex("#1A2196"))
                            .frame(width: 12, height: 12)
                        
                        Spacer()
                        
                        // Step 3 indicator (upcoming)
                        Circle()
                            .fill(Color.gray.opacity(0.5))
                            .frame(width: 12, height: 12)
                    }
                    .padding(.horizontal, 16)
                }
                .padding(.horizontal, 16)
                
                Text("Step 2 of 3")
                    .font(.custom("Magistral", size: 14))
                    .foregroundColor(.gray)
                    .padding(.top, 8)
                    .padding(.bottom, 24)
                
                // Main heading
                Text("What do you value?")
                    .font(.custom("Magistral", size: 28))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 24)
                
                // Selection instructions
                Text("Values & Interests (Select Up to \(maxInterests))")
                    .font(.custom("Magistral", size: 16))
                    .foregroundColor(.white.opacity(0.7))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 24)
                    .padding(.top, 4)
                    .padding(.bottom, 24)
                
                // Max selection warning
                if showMaxSelectionWarning {
                    Text("You can select up to \(maxInterests) interests")
                        .font(.custom("Magistral", size: 14))
                        .foregroundColor(.red.opacity(0.8))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 24)
                        .padding(.bottom, 8)
                }
                
                // Scrollable container for interests
                ScrollView {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 100, maximum: 120), spacing: 20)], spacing: 20) {
                        ForEach(allInterests, id: \.self) { interest in
                            InterestButton(
                                interest: interest, 
                                isSelected: selectedInterests.contains(interest),
                                onTap: {
                                    toggleInterest(interest)
                                }
                            )
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 24)
                }
                
                Spacer()
                
                // Continue button
                Button(action: {
                    if isFormValid {
                        onContinue(Array(selectedInterests))
                    }
                }) {
                    HStack(spacing: 8) {
                        Text("Continue")
                            .font(.custom("Magistral", size: 18))
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                        
                        Image(systemName: "arrow.right")
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity, minHeight: 56)
                    .background(isFormValid ? Color.fromHex("#1A2196") : Color.fromHex("#1A2196").opacity(0.5))
                    .cornerRadius(8)
                }
                .disabled(!isFormValid)
                .padding(.horizontal, 24)
                .padding(.bottom, 32)
            }
        }
    }
    
    // Handle interest selection/deselection
    private func toggleInterest(_ interest: Interest) {
        // Provide haptic feedback
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.prepare()
        
        if selectedInterests.contains(interest) {
            selectedInterests.remove(interest)
            showMaxSelectionWarning = false
            generator.impactOccurred()
        } else {
            if selectedInterests.count < maxInterests {
                selectedInterests.insert(interest)
                showMaxSelectionWarning = false
                generator.impactOccurred()
            } else {
                showMaxSelectionWarning = true
                // Error haptic feedback for max selection reached
                let errorGenerator = UINotificationFeedbackGenerator()
                errorGenerator.notificationOccurred(.warning)
            }
        }
    }
}

// Custom interest button component with image assets
struct InterestButton: View {
    let interest: Interest
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            ZStack {
                // Just use text placeholder during development until image assets are properly set up
                Text(interest.rawValue)
                    .font(.custom("Magistral", size: 14))
                    .foregroundColor(isSelected ? .white : .gray)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 12)
                    .frame(width: 100, height: 100)
                    .background(
                        Circle()
                            .fill(isSelected ? Color.fromHex("#1A2196") : Color.black.opacity(0.6))
                            .overlay(
                                Circle()
                                    .stroke(Color.white.opacity(isSelected ? 0.9 : 0.3), lineWidth: isSelected ? 2 : 1)
                            )
                    )
            }
        }
        .animation(.spring(), value: isSelected)
    }
}

// Preview for development
struct OnboardingStep2View_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingStep2View(onContinue: { _ in })
    }
}
