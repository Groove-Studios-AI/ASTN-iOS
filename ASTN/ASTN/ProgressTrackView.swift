import SwiftUI

struct ProgressTrackView: View {
    // Progress percentage (0.0 to 1.0)
    var progress: CGFloat
    // Whether we're currently animating
    var isAnimating: Bool = false
    
    // Brand colors
    private let brandBlue = Color.fromHex("#1A2196")
    private let brandGold = Color.fromHex("#E8D5B5")
    private let darkBackground = Color.black.opacity(0.95) // Very dark background for track
    
    var body: some View {
        ZStack {
            // Dark background for track
            Rectangle()
                .fill(darkBackground)
                .frame(width: 20, height: 420)
                .cornerRadius(0)
            
            // Track elements on top
            ZStack(alignment: .center) {
                // Dotted line track - centered
                Path { path in
                    path.move(to: CGPoint(x: 0, y: -170))
                    path.addLine(to: CGPoint(x: 0, y: 170))
                }
                .stroke(style: StrokeStyle(lineWidth: 2, dash: [5, 5]))
                .foregroundColor(Color.white.opacity(0.5))
                
                // Computer at top
                ZStack {
                    // Simplified laptop shape
                    RoundedRectangle(cornerRadius: 3)
                        .fill(brandGold)
                        .frame(width: 25, height: 20)
                    
                    // Screen
                    RoundedRectangle(cornerRadius: 2)
                        .fill(brandGold)
                        .frame(width: 20, height: 12)
                        .offset(y: -4)
                }
                .rotationEffect(.degrees(180)) // Flip upside down to match screenshot
                .offset(y: -170)
                
                // Money bag with dollar sign
                ZStack {
                    // Blue circle background
                    Circle()
                        .fill(brandBlue)
                        .frame(width: 35, height: 35)
                    
                    // Dollar sign
                    Text("$")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.white)
                }
                // Calculate position based on progress - moves UP as progress increases
                .offset(y: calculateMoneyBagPosition())
                
                // Bottom light beige pill
                VStack {
                    Capsule()
                        .fill(brandGold)
                        .frame(width: 35, height: 90)
                }
                .offset(y: 210)
            }
        }
        .frame(width: 20, height: 500)
        // Enhanced spring animation with a little bounce
        .animation(.spring(response: 0.8, dampingFraction: 0.7, blendDuration: 0.6), value: progress)
    }
    
    // Calculate the vertical position of the money bag
    private func calculateMoneyBagPosition() -> CGFloat {
        // Animation starts at bottom and moves to top as progress increases
        let startPosition: CGFloat = 170  // Position at the bottom
        let endPosition: CGFloat = -170   // Position at the top (higher than before)
        
        // Linear interpolation with progress
        return startPosition - (progress * (startPosition - endPosition))
    }
}

#Preview {
    ZStack {
        Color.black.edgesIgnoringSafeArea(.all)
        ProgressTrackView(progress: 0.5)
    }
}
