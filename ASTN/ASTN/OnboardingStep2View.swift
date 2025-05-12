import SwiftUI

struct OnboardingStep2View: View {
    // Callback when the user continues to the next step
    var onContinue: ([Interest]) -> Void
    
    // State for selections
    @State private var selectedInterests = Set<Interest>()
    @State private var showMaxSelectionWarning = false
    
    // Colors
    private let brandBlue = Color.fromHex("#1A2196")
    private let brandBlack = Color.fromHex("#0A0A0A")
    
    // Max number of interests
    private let maxInterests = 10
    
    // Form validation
    private var isFormValid: Bool {
        !selectedInterests.isEmpty
    }
    
    // Random positioning of interest bubbles
    private let interestLayouts: [InterestLayout] = [
        // Center large interests
        InterestLayout(interest: .education, size: .large, position: .center),
        InterestLayout(interest: .entrepreneurship, size: .large, position: .bottomCenter),
        InterestLayout(interest: .familyAndRelationships, size: .large, position: .topLeft),
        
        // Medium interests
        InterestLayout(interest: .healthAndWellness, size: .medium, position: .centerRight),
        InterestLayout(interest: .technology, size: .medium, position: .topRight),
        InterestLayout(interest: .music, size: .medium, position: .centerLeft),
        InterestLayout(interest: .artAndCulture, size: .medium, position: .bottomRight),
        InterestLayout(interest: .travel, size: .medium, position: .middle),
        
        // Small interests
        InterestLayout(interest: .sustainability, size: .small, position: .bottomLeft),
        InterestLayout(interest: .innovation, size: .small, position: .topLeft),
        InterestLayout(interest: .fitness, size: .small, position: .bottomLeft),
        InterestLayout(interest: .commerce, size: .small, position: .centerRight),
        InterestLayout(interest: .animalWelfare, size: .small, position: .topRight),
        InterestLayout(interest: .foodAndCooking, size: .small, position: .bottomRight),
        InterestLayout(interest: .communityEngagement, size: .small, position: .bottomLeft),
        InterestLayout(interest: .adventureAndOutdoor, size: .small, position: .centerLeft),
        InterestLayout(interest: .mentalHealth, size: .small, position: .bottom),
        InterestLayout(interest: .gaming, size: .small, position: .bottomCenter),
        InterestLayout(interest: .fashion, size: .small, position: .topLeft),
        InterestLayout(interest: .environmentalConservation, size: .small, position: .topRight)
    ]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Progress indicator
                ProgressIndicator(currentStep: 2, totalSteps: 3)
                    .padding(.bottom, 5)
                
                // Main heading
                Text("What do you value?")
                    .font(.custom("Magistral", size: 28))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.bottom, 5)
                
                // Selection instructions
                Text("Values & Interests (Select Up to \(maxInterests))")
                    .font(.custom("Magistral", size: 16))
                    .foregroundColor(.white.opacity(0.7))
                    .padding(.bottom, 20)
                
                // Max selection warning
                if showMaxSelectionWarning {
                    Text("You can select at most \(maxInterests) interests")
                        .font(.custom("Magistral", size: 14))
                        .foregroundColor(.red.opacity(0.8))
                        .padding(.bottom, 10)
                }
                
                // Interest bubbles
                ZStack {
                    ForEach(interestLayouts, id: \.interest) { layout in
                        InterestBubble(
                            interest: layout.interest,
                            isSelected: selectedInterests.contains(layout.interest),
                            size: layout.size,
                            onTap: { interest in
                                toggleInterest(interest)
                            }
                        )
                        .offset(layout.offset)
                    }
                }
                .frame(height: 600)
                .padding(.bottom, 20)
                
                Spacer()
                
                // Continue button
                Button(action: {
                    if isFormValid {
                        onContinue(Array(selectedInterests))
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
    
    // Handle interest selection/deselection
    private func toggleInterest(_ interest: Interest) {
        if selectedInterests.contains(interest) {
            selectedInterests.remove(interest)
            showMaxSelectionWarning = false
        } else {
            if selectedInterests.count < maxInterests {
                selectedInterests.insert(interest)
                showMaxSelectionWarning = false
            } else {
                showMaxSelectionWarning = true
            }
        }
    }
}

// Interest layout for dynamic positioning
struct InterestLayout {
    let interest: Interest
    let size: InterestBubbleSize
    let position: BubblePosition
    
    var offset: CGSize {
        switch position {
        case .topLeft:
            return CGSize(width: -100, height: -180)
        case .topRight:
            return CGSize(width: 100, height: -180)
        case .bottomLeft:
            return CGSize(width: -100, height: 180)
        case .bottomRight:
            return CGSize(width: 100, height: 180)
        case .center:
            return CGSize(width: 0, height: 0)
        case .centerLeft:
            return CGSize(width: -120, height: 0)
        case .centerRight:
            return CGSize(width: 120, height: 0)
        case .topCenter:
            return CGSize(width: 0, height: -180)
        case .bottomCenter:
            return CGSize(width: 0, height: 180)
        case .middle:
            return CGSize(width: 0, height: -60)
        case .bottom:
            return CGSize(width: 0, height: 120)
        }
    }
}

// Bubble positions for layout
enum BubblePosition {
    case topLeft, topRight, bottomLeft, bottomRight, center
    case centerLeft, centerRight, topCenter, bottomCenter, middle, bottom
}

// Interest bubble component for step 2
struct InterestBubble: View {
    let interest: Interest
    let isSelected: Bool
    let size: InterestBubbleSize
    let onTap: (Interest) -> Void
    
    var body: some View {
        Text(interest.rawValue)
            .font(.custom("Magistral", size: fontSize))
            .foregroundColor(.white)
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .frame(height: height)
            .background(
                Circle()
                    .fill(isSelected ? Color.fromHex("#1A2196").opacity(0.8) : Color.black.opacity(0.6))
                    .overlay(
                        Circle()
                            .stroke(Color.white.opacity(isSelected ? 0.9 : 0.3), lineWidth: isSelected ? 2 : 1)
                    )
            )
            .onTapGesture {
                withAnimation(.spring()) {
                    onTap(interest)
                }
            }
    }
    
    // Dynamic sizing based on bubble size
    private var fontSize: CGFloat {
        switch size {
        case .small: return 12
        case .medium: return 14
        case .large: return 16
        }
    }
    
    private var height: CGFloat {
        switch size {
        case .small: return 70
        case .medium: return 80
        case .large: return 90
        }
    }
}

// Bubble size enumeration
enum InterestBubbleSize {
    case small, medium, large
}

// Preview for development
struct OnboardingStep2View_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            OnboardingStep2View(onContinue: { _ in })
        }
    }
}
