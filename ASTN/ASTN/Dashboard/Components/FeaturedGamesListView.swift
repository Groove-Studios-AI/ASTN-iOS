import SwiftUI

struct FeaturedGamesListView: View {
    let games: [FeaturedGame]
    let onGameSelected: (FeaturedGame) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Section title
            Text("Featured Workouts")
                .font(.custom("Magistral", size: 20))
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.horizontal, 20)
            
            // Horizontal scrollable cards
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    // Add padding at the start for better visual layout
                    Spacer()
                        .frame(width: 8)
                    
                    // Game cards
                    ForEach(games) { game in
                        FeaturedGameCard(
                            game: game,
                            onTap: { onGameSelected(game) }
                        )
                    }
                    
                    // Add padding at the end for better visual layout
                    Spacer()
                        .frame(width: 8)
                }
                .padding(.vertical, 12)
            }
        }
    }
}

struct FeaturedGamesListView_Previews: PreviewProvider {
    static var previews: some View {
        FeaturedGamesListView(
            games: [
                FeaturedGame(
                    title: "GAME OF THE WEEK",
                    gameName: "Attention",
                    iconName: "target",
                    highScore: "11883",
                    difficulty: "17/40",
                    ranking: "19.6%",
                    backgroundColor: "#1E1E1E",
                    gameType: .attention
                ),
                FeaturedGame(
                    title: "POPULAR",
                    gameName: "Estimation",
                    iconName: "waveform",
                    highScore: "9754",
                    difficulty: "14/40",
                    ranking: "23.7%",
                    backgroundColor: "#1B2D3A",
                    gameType: .estimation
                )
            ],
            onGameSelected: { _ in }
        )
        .previewLayout(.sizeThatFits)
        .padding(.vertical)
        .background(Color.black)
    }
}
