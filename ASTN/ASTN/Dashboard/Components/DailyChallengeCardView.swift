import SwiftUI

struct DailyChallengeCardView: View {
    let challengeTitle: String
    let progress: (Int, Int) // (current, total)
    let buttonTitle: String
    let onButtonPressed: () -> Void
    
    // Brand colors
    private let brandBlack = Color.fromHex("#0A0A0A")
    private let brandWhite = Color.fromHex("#F7F5F6")
    private let brandGold = Color.fromHex("#E8D5B5")
    private let brandBlue = Color.fromHex("#1A2196")
    private let brandRed = Color.red.opacity(0.8)
    
    var body: some View {
        VStack(spacing: 24) {
            HStack(alignment: .center) {
                // Challenge text
                Text(challengeTitle)
                    .font(.custom("Magistral", size: 22).weight(.medium))
                    .foregroundColor(brandWhite)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.trailing, 8)
                
                Spacer()
                
                // Progress circle
                ZStack {
                    // Background circle
                    Circle()
                        .stroke(
                            Color.gray.opacity(0.3),
                            lineWidth: 8
                        )
                        .frame(width: 70, height: 70)
                    
                    // Progress circle
                    Circle()
                        .trim(from: 0, to: CGFloat(progress.0) / CGFloat(progress.1))
                        .stroke(
                            brandGold,
                            style: StrokeStyle(
                                lineWidth: 8,
                                lineCap: .round
                            )
                        )
                        .rotationEffect(.degrees(-90))
                        .frame(width: 70, height: 70)
                    
                    // Progress text
                    Text("\(progress.0)/\(progress.1)")
                        .font(.custom("Magistral", size: 20).bold())
                        .foregroundColor(brandWhite)
                }
                .frame(width: 70, height: 70)
            }
            
            // Action button
            Button(action: onButtonPressed) {
                Text(buttonTitle)
                    .font(.custom("Magistral", size: 18).bold())
                    .foregroundColor(brandWhite)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(brandBlue)
                    .cornerRadius(8)
            }
        }
        .padding(24)
        .background(brandBlack)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(brandRed, lineWidth: 2)
        )
    }
}

struct DailyChallengeCardView_Previews: PreviewProvider {
    static var previews: some View {
        DailyChallengeCardView(
            challengeTitle: "You're one Brand module away from unlocking your next performance insight!",
            progress: (2, 3),
            buttonTitle: "Go To Brand Module 3",
            onButtonPressed: {}
        )
        .padding()
        .background(Color.black)
        .previewLayout(.sizeThatFits)
    }
}
