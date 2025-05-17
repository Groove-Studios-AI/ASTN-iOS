import SwiftUI

struct GameResultView: View {
    let score: Int
    let speedyAnswers: Int
    let livesRemaining: Int
    let gameType: GameResult.GameType
    let onContinue: () -> Void
    
    // Environment to hide the navigation bar back button
    @Environment(\.presentationMode) var presentationMode
    
    // Brand colors
    private let brandBlue = Color.fromHex("#1A2196")
    
    var body: some View {
        ZStack {
            // Black background
            Color.black.edgesIgnoringSafeArea(.all)
            
            // Content
            VStack(spacing: 30) {
                Spacer()
                
                // High score hexagon with piggy bank
                ZStack {
                    // Blue hexagon background
                    Image("polygon_HighScore")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 180, height: 180)
                    
                    // Piggy bank icon - centered on top of the hexagon
                    Image("piggyBank_HighScore")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
                }
                
                // Score display
                Text("\(score)")
                    .font(.custom("Magistral", size: 60))
                    .foregroundColor(brandBlue)
                    .fontWeight(.bold)
                
                // Message
                Text("GREAT JOB! HIGH SCORE!")
                    .font(.custom("Magistral", size: 24))
                    .foregroundColor(.white)
                    .kerning(1.5)
                
                // Horizontal divider
                Rectangle()
                    .fill(Color.white.opacity(0.3))
                    .frame(height: 1)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                
                // Performance metrics
                VStack(spacing: 15) {
                    HStack {
                        Text("Speedy Answers:")
                            .font(.custom("Magistral", size: 18))
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Text("\(speedyAnswers)")
                            .font(.custom("Magistral", size: 18))
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                    }
                    
                    HStack {
                        Text("Lives Remaining:")
                            .font(.custom("Magistral", size: 18))
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Text("\(livesRemaining)")
                            .font(.custom("Magistral", size: 18))
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                    }
                }
                .padding(.horizontal, 40)
                
                Spacer()
                
                // Tap to continue
                Text("TAP TO CONTINUE")
                    .font(.custom("Magistral", size: 14))
                    .foregroundColor(Color.white.opacity(0.6))
                    .padding(.bottom, 30)
            }
            .padding()
        }
        // Tap gesture to continue
        .onTapGesture {
            onContinue()
        }
        // Hide the navigation bar back button
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
}

struct GameResultView_Previews: PreviewProvider {
    static var previews: some View {
        GameResultView(
            score: 217,
            speedyAnswers: 8,
            livesRemaining: 4,
            gameType: .speedStreak,
            onContinue: {}
        )
    }
}
