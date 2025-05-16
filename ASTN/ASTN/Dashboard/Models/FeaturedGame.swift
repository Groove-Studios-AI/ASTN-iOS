import Foundation

struct FeaturedGame: Identifiable {
    let id = UUID()
    let title: String           // e.g. "GAME OF THE WEEK", "POPULAR"
    let gameName: String        // e.g. "Attention", "Estimation"
    let iconName: String        // SF Symbol or custom icon name
    let highScore: String
    let difficulty: String
    let ranking: String         // e.g. "19.6%"
    let backgroundColor: String // Hex color
    
    // For navigation purposes
    let gameType: GameType
    
    enum GameType: String {
        case speedStreak = "Speed Streak"
        case brandBuilder = "Brand Builder"
        case attention = "Attention"
        case estimation = "Estimation"
        case upcoming = "Upcoming"
    }
}
