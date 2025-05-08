import SwiftUI

struct CircularProgressView: View {
    let progress: Double
    let strokeWidth: CGFloat
    let fontSize: CGFloat
    let maxValue: Int
    
    var body: some View {
        ZStack {
            // Background circle
            Circle()
                .stroke(lineWidth: strokeWidth)
                .opacity(0.3)
                .foregroundColor(Color.fromHex("#7A6BFF").opacity(0.3))
            
            // Progress circle
            Circle()
                .trim(from: 0.0, to: CGFloat(min(self.progress, 1.0)))
                .stroke(style: StrokeStyle(
                    lineWidth: strokeWidth,
                    lineCap: .round,
                    lineJoin: .round
                ))
                .foregroundColor(Color.fromHex("#7A6BFF"))
                .rotationEffect(Angle(degrees: 270.0))
                .animation(.linear, value: progress)
            
            // Text label
            Text("\(Int(progress * Double(maxValue)))/\(maxValue)")
                .font(.custom("Magistral", size: fontSize).bold())
                .foregroundColor(.white)
        }
    }
}
