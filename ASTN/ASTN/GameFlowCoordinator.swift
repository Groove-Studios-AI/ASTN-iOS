import SwiftUI
import Combine

// Game result data structure to pass between views
struct GameResult {
    let score: Int
    let speedyAnswers: Int
    let livesRemaining: Int
    let gameType: GameType
    
    enum GameType {
        case speedStreak
        case brandBuilder
    }
}

// Investment opportunity data structure
struct InvestmentOpportunity: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let subtitle: String
    let rating: Double
    let investorCount: Int
    let percentage: String
    let imageAsset: String
    
    // Sample investment opportunity
    static let johnnysExample = InvestmentOpportunity(
        title: "Johnny's Pizza",
        description: "Join a select group of athletes with a 0.75% stakeholder partnership in Johnny's Pizza's newest location, focusing on customer satisfaction and turnout.",
        subtitle: "Equity Partnership",
        rating: 4.5,
        investorCount: 84,
        percentage: "0.75%",
        imageAsset: "johnnys"
    )
}

// Game flow coordinator to manage state transitions
class GameFlowCoordinator: ObservableObject {
    @Published var currentScreen: GameEndScreen = .none
    @Published var gameResult: GameResult?
    @Published var investmentOffer: InvestmentOpportunity?
    @Published var showDeclineConfirmation: Bool = false
    
    enum GameEndScreen {
        case none
        case results
        case investment
        case premium
    }
    
    // Called when game is complete
    func completeGame(result: GameResult) {
        self.gameResult = result
        self.currentScreen = .results
    }
    
    // Show investment opportunity
    func showInvestment() {
        // For now, we'll always show Johnny's Pizza
        self.investmentOffer = InvestmentOpportunity.johnnysExample
        self.currentScreen = .investment
    }
    
    // Handle decline action with confirmation
    func promptDeclineConfirmation() {
        self.showDeclineConfirmation = true
    }
    
    // Confirm decline and move to premium screen
    func confirmDecline() {
        self.showDeclineConfirmation = false
        self.currentScreen = .premium
    }
    
    // Cancel decline
    func cancelDecline() {
        self.showDeclineConfirmation = false
    }
    
    // Handle investment inquiry
    func inquireAboutInvestment() {
        // In a real app, this would record interest and possibly contact info
        self.currentScreen = .premium
    }
    
    // Return to dashboard
    func returnHome() {
        self.currentScreen = .none
        // Navigation would happen in the view
    }
    
    // Handle premium subscription
    func unlockPremium() {
        // In a real app, this would start the subscription flow
        print("Premium subscription flow initiated")
    }
}
