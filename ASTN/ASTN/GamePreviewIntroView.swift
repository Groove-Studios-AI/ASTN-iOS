import SwiftUI

struct GamePreviewIntroView: View {
    // Callback when the user continues to the next step
    var onContinue: () -> Void
    
    // Colors
    private let brandBlack = Color.fromHex("#0A0A0A")
    private let brandBlue = Color.fromHex("#1A2196")
    private let brandWhite = Color.fromHex("#F7F5F6")
    
    var body: some View {
        ZStack {
            // Background
            brandBlack.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                // Header with ASTN Logo
                HStack {
                    Spacer()
                    Image("ASTN_LaunchLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 40)
                    Spacer()
                }
                .padding(.top, 16)
                .padding(.bottom, 16)
                
                // Progress indicator
                ZStack(alignment: .leading) {
                    // Background track
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 3)
                    
                    // Blue progress indicator - 25% progress
                    Rectangle()
                        .fill(brandBlue)
                        .frame(width: UIScreen.main.bounds.width * 0.25, height: 3)
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 40)
                
                // Puzzle image
                Image(systemName: "puzzlepiece.fill") // Using SF Symbol as placeholder
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(Color.fromHex("#4CD964")) // Green puzzle piece
                    .frame(width: 200, height: 200)
                    .padding(.bottom, 40)
                    .overlay(
                        ZStack {
                            Image(systemName: "puzzlepiece.fill")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(Color.fromHex("#FFCC00")) // Yellow puzzle piece
                                .frame(width: 100, height: 100)
                                .offset(x: 50, y: -50)
                            
                            Image(systemName: "puzzlepiece.fill")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(Color.fromHex("#007AFF")) // Blue puzzle piece
                                .frame(width: 100, height: 100)
                                .offset(x: 50, y: 50)
                            
                            Image(systemName: "puzzlepiece.fill")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(Color.fromHex("#FF3B30")) // Red puzzle piece
                                .frame(width: 100, height: 100)
                                .offset(x: -50, y: 50)
                        }
                    )
                
                // Title
                Text("Awesome! Now let's take the\nCommunication Score Test.")
                    .font(.custom("Magistral", size: 24))
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .foregroundColor(brandWhite)
                    .padding(.horizontal, 24)
                    .padding(.bottom, 16)
                
                // Description
                Text("This test evaluates your communication efficiency, confidence, and adaptability in a unique and engaging way.")
                    .font(.custom("Magistral", size: 16))
                    .multilineTextAlignment(.center)
                    .foregroundColor(brandWhite.opacity(0.7))
                    .padding(.horizontal, 24)
                    .padding(.bottom, 40)
                
                Spacer()
                
                // Continue button
                Button(action: {
                    onContinue()
                }) {
                    Text("Continue")
                        .font(.custom("Magistral", size: 18))
                        .fontWeight(.medium)
                        .foregroundColor(brandWhite)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(brandBlue)
                        .cornerRadius(8)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 32)
            }
        }
    }
}

#Preview {
    GamePreviewIntroView(onContinue: {})
}
