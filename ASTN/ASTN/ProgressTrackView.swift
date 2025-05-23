import SwiftUI

struct ProgressTrackView: View {
    // Progress percentage (0.0 to 1.0)
    var progress: CGFloat
    // Whether we're currently animating
    var isAnimating: Bool = false
    
    // Fixed dimensions based on asset proportions
    private let trackWidth: CGFloat = 20
    private let trackHeight: CGFloat = 600
    private let iconSize: CGFloat = 40
    private let fillInWidth: CGFloat = 38
    
    var body: some View {
        // The entire track component
        VStack(spacing: 0) {
            // Top spacing to position correctly with blue dots
            Spacer()
                .frame(height: 50)
            
            // Main track component using provided images
            ZStack(alignment: .top) {
                // Track image (vertical dotted line track)
                Image("SpeedProgressTrack")
                    .resizable()
                    .frame(width: trackWidth, height: trackHeight)
                
                // Piggy bank at top
                Image("piggyBank")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: iconSize, height: iconSize)
                    .offset(y: 15)
                
                // Speed car - animated element
                Image("speedCar")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: iconSize * 2, height: iconSize * 2)
                    // Position based on progress (0.0-1.0), moves up as progress increases
                    .offset(y: calculateMovingElementPosition())
                
                // Progress fill-in at bottom
                Image("SpeedProgressFillIn")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: fillInWidth)
                    .offset(y: trackHeight - 80) // Positioned at the bottom
            }
            // Center the track
            .frame(width: trackWidth)
        }
        // Enhanced spring animation with a little bounce
        .animation(.spring(response: 0.8, dampingFraction: 0.7, blendDuration: 0.6), value: progress)
    }
    
    // Calculate the vertical position of the moving element
    private func calculateMovingElementPosition() -> CGFloat {
        // Animation starts at bottom and moves to top as progress increases
        let startPosition: CGFloat = trackHeight - 100  // Position at the bottom above the fill-in
        let endPosition: CGFloat = 50                   // Position at the top near piggy bank
        
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
