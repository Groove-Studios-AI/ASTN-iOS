import SwiftUI

struct OwnershipView: View {
    // Colors
    private let cardBackground = Color.fromHex("#1E2060") // Dark navy/purple
    private let cardBackgroundDarker = Color.fromHex("#151849") // Darker shade for layered effect
    private let primaryText = Color.white
    private let secondaryText = Color.white.opacity(0.8)
    private let accentGold = Color.fromHex("#E8D5B5") // Gold accent color
    private let iconPurple = Color.fromHex("#B6A4FF") // Light purple for icon
    private let iconBackground = Color.fromHex("#2E2C7C") // Darker purple for icon background
    
    // Action callback
    var onTap: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Section header (outside the card, on black background)
            Text("Explore Ownership Opportunities")
                .font(.custom("Magistral", size: 20).bold())
                .foregroundColor(.white)
                .padding(.horizontal)
            
            // Card with ownership opportunities
            Button(action: onTap) {
                ZStack {
                    // Card background
                    RoundedRectangle(cornerRadius: 18)
                        .fill(cardBackground)
                    
                    // Content container
                    VStack(spacing: 0) { // Remove default spacing to control precise spacing
                        // Dollar icon with dual ellipse design
                        ZStack {
                            // Outer ellipse
                            Ellipse()
                                .fill(iconBackground)
                                .frame(width: 65, height: 55)
                            
                            // Dollar sign with inner circle
                            Image(systemName: "dollarsign.circle.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .foregroundColor(iconPurple)
                                .frame(width: 34, height: 34)
                        }
                        .padding(.top, 8) // 8px from top of purple view
                        
                        // Title and description - 13px spacing from dollar sign
                        VStack(spacing: 8) {
                            Text("Ownership Opportunities")
                                .font(.custom("Magistral", size: 22).bold())
                                .foregroundColor(primaryText)
                                .multilineTextAlignment(.center)
                                .padding(.top, 13) // 13px spacing from dollar sign
                            
                            Text("Discover ways to build lasting wealth\nthrough ownership")
                                .font(.custom("Magistral", size: 15))
                                .foregroundColor(secondaryText)
                                .multilineTextAlignment(.center)
                                .lineSpacing(6) // Approximately 1.5x line spacing
                                .lineLimit(2)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .padding(.horizontal, 20)
                        
                        Spacer()
                        
                        // Call to action at bottom with 12px from bottom edge
                        Text("Tap to explore options")
                            .font(.custom("Magistral", size: 16))
                            .foregroundColor(accentGold)
                            .padding(.bottom, 12)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 180) // Fixed height for consistency
                }
                .cornerRadius(18)
            }
            .buttonStyle(PlainButtonStyle())
            .padding(.horizontal)
        }
    }
}

// Preview for development
struct OwnershipView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            OwnershipView(onTap: {})
        }
    }
}
