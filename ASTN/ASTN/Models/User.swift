import Foundation

// Core User Model based on the comprehensive schema
struct User: Codable {
    // MARK: - Core Identity & Profile
    var id: String                            // UUID or similar
    var authMethod: AuthMethod
    var createdAt: Date
    var lastActive: Date
    
    // Demographic & Athlete Data
    var athleteType: AthleteType?             // Set during onboarding step 1
    var sport: String?                        // Set during onboarding step 1
    var level: String?                        // Division/league
    var yearsAtLevel: Int?
    var age: Int?                             // Optional for privacy
    var location: Location?
    
    // Psychographic Segmentation
    var mindsetProfile: MindsetProfile?       // Set during onboarding
    var interests: [Interest]?                // Set during onboarding step 2
    var initialSkillLevel: SkillLevel?        // Self-assessed
    
    // MARK: - Journey State & Engagement
    var onboarding: OnboardingState
    var currentStage: UserStage
    var modulesCompleted: ModulesCompleted?
    var gameSessions: [GameSession]?
    var retentionMetrics: RetentionMetrics?
    
    // MARK: - Behavioral & Gamification Data
    var gamePerformance: GamePerformance?
    var points: PointsData?
    var churnRisk: Int?                       // 0-100 score
    var preferredContentType: ContentType?    // For personalization
    
    // MARK: - Monetization & System Data
    var accountTier: AccountTier
    var premiumConversion: PremiumConversion?
    var purchaseHistory: [Purchase]?
    var device: DeviceInfo?
    var notifications: [NotificationEvent]?
    
    // Tracking email/name for login purposes
    var email: String
    var name: String?
    
    // Init with minimal required fields for new user creation
    init(id: String, email: String, authMethod: AuthMethod) {
        self.id = id
        self.email = email
        self.authMethod = authMethod
        self.createdAt = Date()
        self.lastActive = Date()
        self.onboarding = OnboardingState()
        self.currentStage = .onboarding
        self.accountTier = .freemium
    }
}

// MARK: - Support Types

// Auth Method
enum AuthMethod: String, Codable {
    case email, magicLink, social
}

// Athlete Type (Step 1 of onboarding)
enum AthleteType: String, Codable {
    case professional = "Professional Athlete"
    case college = "College Athlete"
    case highSchool = "High School Athlete"
    case retired = "Retired Athlete"
    case amateur = "Amateur Athlete"
    case paralympic = "Paralympic Athlete"
    case eSports = "eSports Athlete"
}

// Location data
struct Location: Codable {
    var city: String
    var state: String?
    var country: String
}

// Mindset Profile
enum MindsetProfile: String, Codable {
    case growth = "Growth"
    case legacy = "Legacy"
    case security = "Security"
}

// Interest areas (Step 2 of onboarding)
enum Interest: String, Codable, CaseIterable {
    case familyAndRelationships = "Family and Relationships"
    case education = "Education"
    case music = "Music"
    case technology = "Technology"
    case travel = "Travel"
    case healthAndWellness = "Health and Wellness"
    case innovation = "Innovation"
    case artAndCulture = "Art and Culture"
    case commerce = "Commerce"
    case fitness = "Fitness"
    case entrepreneurship = "Entrepreneurship"
    case sustainability = "Sustainability"
    case animalWelfare = "Animal Welfare"
    case foodAndCooking = "Food and Cooking"
    case communityEngagement = "Community Engagement"
    case adventureAndOutdoor = "Adventure and Outdoor Activities"
    case mentalHealth = "Mental Health"
    case gaming = "Gaming"
    case fashion = "Fashion"
    case environmentalConservation = "Environmental Conservation"
}

// Skill level self-assessment
enum SkillLevel: String, Codable {
    case low = "Low"
    case medium = "Medium"
    case high = "High"
}

// Onboarding state
struct OnboardingState: Codable {
    var surveyCompleted: Bool = false
    var completionTimestamp: Date?
    var currentStep: Int = 1
    var stepsCompleted: Int = 0
    var totalSteps: Int = 3
}

// User stage in journey
enum UserStage: String, Codable {
    case onboarding, active, dormant
}

// Module completion tracking
struct ModulesCompleted: Codable {
    var wealth: Int = 0
    var brand: Int = 0
    var lastCompleted: Date?
}

// Game session records
struct GameSession: Codable {
    var moduleId: String
    var startTime: Date
    var duration: Int          // in seconds
    var score: Int
    var livesUsed: Int?
    var outcome: GameOutcome
}

enum GameOutcome: String, Codable {
    case success, fail
}

// Retention tracking
struct RetentionMetrics: Codable {
    var streakDays: Int = 0
    var sessionFrequency: Double = 0  // Avg sessions per week
    var day1Retention: Bool = false
}

// Game performance metrics
struct GamePerformance: Codable {
    var smartSpendScale: SmartSpendScale?
    var awarenessTracker: AwarenessTracker?
    
    struct SmartSpendScale: Codable {
        var avgBalanceTime: Double?
        var instabilityEvents: Int?
    }
    
    struct AwarenessTracker: Codable {
        var accuracy: Double?
    }
}

// Points and rewards
struct PointsData: Codable {
    var totalEarned: Int = 0
    var burnRate: Double = 0
    var rewardsRedeemed: [Reward] = []
    
    struct Reward: Codable {
        var id: String
        var type: RewardType
        var redeemedAt: Date
    }
    
    enum RewardType: String, Codable {
        case merch = "Merch"
        case event = "Event"
        case asset = "Asset"
    }
}

// Content preference
enum ContentType: String, Codable {
    case story = "Story"
    case tactical = "Tactical"
}

// Account tier
enum AccountTier: String, Codable {
    case freemium = "Freemium"
    case premium = "Premium"
}

// Premium conversion tracking
struct PremiumConversion: Codable {
    var date: Date
    var trigger: String
}

// Purchase history
struct Purchase: Codable {
    var itemId: String
    var amount: Double
    var purchaseDate: Date
}

// Device information
struct DeviceInfo: Codable {
    var os: OS
    var version: String
    
    enum OS: String, Codable {
        case iOS, android
    }
}

// Notification engagement
struct NotificationEvent: Codable {
    var type: String
    var opened: Bool
    var sentAt: Date
}

// Learning Goal (Step 3 of onboarding)
enum LearningGoal: String, Codable {
    case wealthBuilding = "Wealth Building"
    case careerBuilding = "Career Building"
    case brandBuilding = "Brand Building"
}
