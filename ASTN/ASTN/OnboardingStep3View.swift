import SwiftUI

struct OnboardingStep3View: View {
    // Callback when the user completes onboarding
    var onContinue: (LearningGoal) -> Void
    
    // State for selection
    @State private var selectedGoal: LearningGoal?
    
    // Colors - using the brand colors from memory
    private let brandBlue = Color.fromHex("#1A2196")
    private let brandGold = Color.fromHex("#E8D5B5")
    private let brandBlack = Color.fromHex("#0A0A0A")
    
    // Form validation
    private var isFormValid: Bool {
        selectedGoal != nil
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Progress indicator
                ProgressIndicator(currentStep: 3, totalSteps: 3)
                    .padding(.bottom, 5)
                
                // Main heading
                Text("What would you like to learn?")
                    .font(.custom("Magistral", size: 28))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.bottom, 5)
                
                // Selection instructions
                Text("Set Your Primary Goal (Current Status)")
                    .font(.custom("Magistral", size: 16))
                    .foregroundColor(.white.opacity(0.7))
                    .padding(.bottom, 20)
                
                // Learning goal options
                VStack(spacing: 16) {
                    // Wealth Building
                    GoalOptionButton(
                        title: LearningGoal.wealthBuilding.rawValue,
                        isSelected: selectedGoal == .wealthBuilding,
                        onTap: {
                            selectedGoal = .wealthBuilding
                        }
                    )
                    
                    // Career Building
                    GoalOptionButton(
                        title: LearningGoal.careerBuilding.rawValue,
                        isSelected: selectedGoal == .careerBuilding,
                        onTap: {
                            selectedGoal = .careerBuilding
                        }
                    )
                    
                    // Brand Building
                    GoalOptionButton(
                        title: LearningGoal.brandBuilding.rawValue,
                        isSelected: selectedGoal == .brandBuilding,
                        onTap: {
                            selectedGoal = .brandBuilding
                        }
                    )
                }
                .padding(.bottom, 30)
                
                Spacer()
                
                // Continue button
                Button(action: {
                    if let goal = selectedGoal {
                        onContinue(goal)
                    }
                }) {
                    HStack {
                        Text("Continue")
                            .font(.custom("Magistral", size: 18))
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Image(systemName: "arrow.right")
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 24)
                    .frame(height: 56)
                    .frame(maxWidth: .infinity)
                    .background(isFormValid ? brandBlue : brandBlue.opacity(0.5))
                    .cornerRadius(8)
                }
                .disabled(!isFormValid)
                .padding(.top, 16)
            }
            .padding([.horizontal, .bottom], 24)
        }
    }
}

// Reusable goal option button
struct GoalOptionButton: View {
    let title: String
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: {
            onTap()
        }) {
            HStack {
                Text(title)
                    .font(.custom("Magistral", size: 16))
                    .foregroundColor(.white)
                    .padding(.leading, 16)
                
                Spacer()
            }
            .frame(height: 56)
            .frame(maxWidth: .infinity)
            .background(
                isSelected 
                ? Color.fromHex("#1A2196") 
                : Color.white.opacity(0.1)
            )
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(
                        isSelected 
                        ? Color.white.opacity(0.5) 
                        : Color.clear, 
                        lineWidth: 1
                    )
            )
        }
    }
}

// Preview for development
struct OnboardingStep3View_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            OnboardingStep3View(onContinue: { _ in })
        }
    }
}
