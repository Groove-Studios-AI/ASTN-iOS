import SwiftUI

struct ProgressIndicator: View {
    var currentStep: Int
    var totalSteps: Int
    
    private let activeColor = Color.fromHex("#1A2196") // Brand blue
    private let inactiveColor = Color.gray.opacity(0.3)
    private let completedColor = Color.fromHex("#1A2196") // Using same brand blue for consistency
    
    var body: some View {
        VStack(spacing: 8) {
            // Progress bar
            HStack(spacing: 0) {
                // Active line
                Rectangle()
                    .fill(activeColor)
                    .frame(width: calculateProgressWidth(), height: 3)
                
                // Inactive line
                Rectangle()
                    .fill(inactiveColor)
                    .frame(width: calculateRemainingWidth(), height: 3)
            }
            .overlay(alignment: .leading) {
                // Dots for each step
                HStack(spacing: getStepSpacing()) {
                    ForEach(1...totalSteps, id: \.self) { step in
                        Circle()
                            .fill(step <= currentStep ? activeColor : inactiveColor)
                            .frame(width: 10, height: 10)
                    }
                }
            }
            
            // Step indicator text
            Text("Step \(currentStep) of \(totalSteps)")
                .font(.custom("Magistral", size: 14))
                .foregroundColor(Color.gray)
        }
    }
    
    // Calculate the width of the active progress bar
    private func calculateProgressWidth() -> CGFloat {
        let progress = CGFloat(currentStep - 1) / CGFloat(totalSteps - 1)
        return UIScreen.main.bounds.width * 0.85 * progress // 85% of screen width for progress bar
    }
    
    // Calculate the width of the inactive progress bar
    private func calculateRemainingWidth() -> CGFloat {
        let remaining = CGFloat(totalSteps - currentStep) / CGFloat(totalSteps - 1)
        return UIScreen.main.bounds.width * 0.85 * remaining // 85% of screen width for progress bar
    }
    
    // Calculate spacing between step dots
    private func getStepSpacing() -> CGFloat {
        return UIScreen.main.bounds.width * 0.85 / CGFloat(totalSteps - 1) - 10 // Account for dot width
    }
}
