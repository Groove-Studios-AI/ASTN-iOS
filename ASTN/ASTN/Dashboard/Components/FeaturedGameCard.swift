import SwiftUI

struct FeaturedGameCard: View {
    let game: FeaturedGame
    let onTap: () -> Void
    
    // Card dimensions
    private let cardWidth: CGFloat = 170
    private let cardHeight: CGFloat = 220
    
    // Brand colors
    private let brandWhite = Color.fromHex("#F7F5F6")
    private let brandBlack = Color.fromHex("#0A0A0A")
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 0) {
                // Header with title
                Text(game.title)
                    .font(.custom("Magistral", size: 10))
                    .fontWeight(.bold)
                    .foregroundColor(brandWhite.opacity(0.7))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 12)
                    .padding(.top, 12)
                    .padding(.bottom, 8)
                
                // Game icon and name
                VStack(spacing: 8) {
                    // Icon (circle)
                    ZStack {
                        Circle()
                            .fill(brandWhite.opacity(0.15))
                            .frame(width: 50, height: 50)
                        
                        if game.iconName.contains("custom_") {
                            // Custom image
                            Image(game.iconName.replacingOccurrences(of: "custom_", with: ""))
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30, height: 30)
                                .foregroundColor(brandWhite)
                        } else {
                            // SF Symbol
                            Image(systemName: game.iconName)
                                .font(.system(size: 24))
                                .foregroundColor(brandWhite)
                        }
                    }
                    .padding(.bottom, 4)
                    
                    // Game name
                    Text(game.gameName)
                        .font(.custom("Magistral", size: 16))
                        .fontWeight(.bold)
                        .foregroundColor(brandWhite)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
                
                Spacer(minLength: 0)
                
                // Stats section
                VStack(alignment: .leading, spacing: 8) {
                    // HIGH SCORE
                    HStack {
                        Text("HIGH SCORE")
                            .font(.custom("Magistral", size: 10))
                            .foregroundColor(brandWhite.opacity(0.7))
                        Spacer()
                        Text(game.highScore)
                            .font(.custom("Magistral", size: 12))
                            .fontWeight(.medium)
                            .foregroundColor(brandWhite)
                    }
                    
                    // DIFFICULTY
                    HStack {
                        Text("DIFFICULTY")
                            .font(.custom("Magistral", size: 10))
                            .foregroundColor(brandWhite.opacity(0.7))
                        Spacer()
                        Text(game.difficulty)
                            .font(.custom("Magistral", size: 12))
                            .fontWeight(.medium)
                            .foregroundColor(brandWhite)
                    }
                    
                    // RANKING
                    HStack {
                        Text("RANKING")
                            .font(.custom("Magistral", size: 10))
                            .foregroundColor(brandWhite.opacity(0.7))
                        Spacer()
                        Text(game.ranking)
                            .font(.custom("Magistral", size: 12))
                            .fontWeight(.medium)
                            .foregroundColor(brandWhite)
                    }
                }
                .padding(.horizontal, 12)
                .padding(.bottom, 16)
            }
            .frame(width: cardWidth, height: cardHeight)
            .background(Color.fromHex(game.backgroundColor))
            .cornerRadius(12)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct FeaturedGameCard_Previews: PreviewProvider {
    static var previews: some View {
        FeaturedGameCard(
            game: FeaturedGame(
                title: "GAME OF THE WEEK",
                gameName: "Attention",
                iconName: "target",
                highScore: "11883",
                difficulty: "17/40",
                ranking: "19.6%",
                backgroundColor: "#1E1E1E",
                gameType: .attention
            ),
            onTap: {}
        )
        .previewLayout(.sizeThatFits)
        .padding()
        .background(Color.black)
    }
}
