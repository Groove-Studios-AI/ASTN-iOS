import SwiftUI

struct ProgressTrackView: View {
    // Progress percentage (0.0 to 1.0)
    var progress: CGFloat
    // Whether we're currently animating
    var isAnimating: Bool = false
    
    // Brand colors
    private let brandBlue = Color.fromHex("#1A2196")
    private let brandGold = Color.fromHex("#E8D5B5")
    
    var body: some View {
        // The entire track component
        VStack(spacing: 0) {
            // Top spacing to position correctly with blue dots
            Spacer()
                .frame(height: 50)
            
            // Main track component
            ZStack(alignment: .top) {
                // Dark track background
                Rectangle()
                    .fill(Color.black)
                    .frame(width: 20, height: 600)
                
                // Dotted line track - centered and extending full height
                Path { path in
                    path.move(to: CGPoint(x: 0, y: 0))
                    path.addLine(to: CGPoint(x: 0, y: 600))
                }
                .stroke(style: StrokeStyle(lineWidth: 2, dash: [5, 5]))
                .foregroundColor(Color.white.opacity(0.5))
                .frame(width: 20, height: 600)
                
                // Computer at top
                VStack {
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
                }
                .offset(y: 15)
                
                // Money bag with dollar sign - animated element
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
                // Position based on progress (0.0-1.0), moves up as progress increases
                .offset(y: calculateMoneyBagPosition())
                
                // Bottom light beige pill (at bottom of track)
                VStack {
                    Capsule()
                        .fill(brandGold)
                        .frame(width: 35, height: 80)
                }
                .offset(y: 520) // Positioned at the bottom
            }
        }
        .frame(width: 20)
        // Enhanced spring animation with a little bounce
        .animation(.spring(response: 0.8, dampingFraction: 0.7, blendDuration: 0.6), value: progress)
    }
    
    // Calculate the vertical position of the money bag
    private func calculateMoneyBagPosition() -> CGFloat {
        // Animation starts at bottom and moves to top as progress increases
        let startPosition: CGFloat = 500  // Position at the bottom
        let endPosition: CGFloat = 50     // Position at the top
        
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
