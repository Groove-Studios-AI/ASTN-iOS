import SwiftUI
import Combine

class DashboardViewModel: ObservableObject {
    @Published var username: String = "Athlete"
    @Published var greeting: String = "Good morning! Let's work today."
    @Published var points: Int = 43
    
    @Published var currentStreak: Int = 6
    @Published var maxStreak: Int = 7
    
    @Published var isPerformanceTrackingOptedIn: Bool = false
    @Published var isOwnershipExpanded: Bool = false
    
    // Daily Challenge Properties
    @Published var showDailyChallenge: Bool = true
    @Published var dailyChallengeTitle: String = "You're one Brand module away from unlocking your next performance insight!"
    @Published var dailyChallengeProgress: (Int, Int) = (2, 3)
    @Published var dailyChallengeButtonTitle: String = "Go To Brand Module 3"
    
    // Sample data - would be fetched from API in real implementation
    @Published var rewards: [RewardItem] = [
        RewardItem(id: "1", title: "Complete 7\nworkouts", isUnlocked: false),
        RewardItem(id: "2", title: "Alt Asset Unlock", isUnlocked: false),
        RewardItem(id: "3", title: "Merch Rewards", isUnlocked: false)
    ]
    
    @Published var articles: [Article] = [
        Article(
            id: "1",
            title: "10 Ways to Build Wealth as an Athlete",
            previewText: "Financial strategies specifically for sports professionals",
            imageURL: nil,
            readTimeMinutes: 5,
            isEditorsChoice: true
        ),
        Article(
            id: "2",
            title: "NIL Deals: What You Need to Know",
            previewText: "Navigating the new landscape of endorsements",
            imageURL: nil,
            readTimeMinutes: 8,
            isEditorsChoice: false
        ),
        Article(
            id: "3",
            title: "Planning Your Career Transition",
            previewText: "Financial preparation for life after sports",
            imageURL: nil,
            readTimeMinutes: 7,
            isEditorsChoice: false
        )
    ]
    
    @Published var videos: [Video] = [
        Video(
            id: "1",
            title: "Contract Negotiation Essentials",
            description: "Learn key negotiation tactics",
            thumbnailURL: nil,
            durationMinutes: 12,
            isPremium: true
        ),
        Video(
            id: "2",
            title: "Investment Portfolio Basics",
            description: "Start building your future today",
            thumbnailURL: nil,
            durationMinutes: 15,
            isPremium: false
        ),
        Video(
            id: "3",
            title: "Brand Building Masterclass",
            description: "With guest stars from the industry",
            thumbnailURL: nil,
            durationMinutes: 20,
            isPremium: false
        )
    ]
    
    @Published var ownershipOptions: [OwnershipOption] = [
        OwnershipOption(
            id: "1",
            title: "Equity",
            description: "Company ownership",
            iconName: "chart.bar.fill"
        ),
        OwnershipOption(
            id: "2",
            title: "Alternative Assets",
            description: "Unique investments",
            iconName: "gift"
        ),
        OwnershipOption(
            id: "3",
            title: "Merch",
            description: "Branded products",
            iconName: "bag"
        )
    ]
    
    init() {
        // In real app, we would initialize with API calls
        updateGreeting()
    }
    
    // MARK: - Helper Methods
    
    private func updateGreeting() {
        let hour = Calendar.current.component(.hour, from: Date())
        
        switch hour {
        case 0..<12:
            greeting = "Good morning! Let's work today."
        case 12..<17:
            greeting = "Good afternoon! Ready to work?"
        default:
            greeting = "Good evening! Not done yet."
        }
    }
    
    // MARK: - Action Methods
    
    func completeWorkout() {
        // In a real app, this would navigate to workout screen
        print("Navigating to workout completion flow")
    }
    
    func navigateToWealthWorkout() {
        // Navigate to wealth workout
        print("Navigating to wealth workout")
    }
    
    func navigateToBrandWorkout() {
        // Navigate to brand workout
        print("Navigating to brand workout")
    }
    
    func showRewardsInfo() {
        // Show rewards info modal
        print("Showing rewards info")
    }
    
    func selectOwnershipOption(_ option: OwnershipOption) {
        // Handle ownership option selection
        print("Selected ownership option: \(option.title)")
    }
    
    func toggleOwnershipExpanded() {
        isOwnershipExpanded.toggle()
    }
    
    // MARK: - Public Methods
    
    func loadDashboardData() {
        // This would fetch real data from APIs
        print("Loading dashboard data")
        // Mock successful load for now
    }
    
    func navigateToDailyChallenge() {
        // In a real app, this would navigate to the appropriate module
        // For this prototype, we'll just mark the challenge as completed
        print("Navigating to daily challenge: \(dailyChallengeButtonTitle)")
        
        // Simulate completion of challenge
        completeDailyChallenge()
    }
    
    func completeDailyChallenge() {
        // Hide the challenge card when completed
        showDailyChallenge = false
        
        // Add points for completing the challenge
        points += 15
    }
}
