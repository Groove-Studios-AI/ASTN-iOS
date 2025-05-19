import Foundation
import UIKit

// Core User Model based on the comprehensive schema
struct User: Codable, Identifiable {
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
    var device: DeviceInfo
    var notifications: NotificationPreferences
    
    // Tracking email/name for login purposes
    var email: String
    var name: String?
    
    // Used to track temporary users created during onboarding
    var isTemporary: Bool = false
    
    // Shorthand for initializing a new user model instance from signup
    static func newUser(id: String, email: String, authMethod: AuthMethod) -> User {
        return User(
            id: id,
            email: email,
            authMethod: authMethod,
            createdAt: Date(),
            lastActive: Date(),
            onboarding: OnboardingState(),
            currentStage: .onboarding,
            accountTier: .freemium,
            device: DeviceInfo(),
            notifications: NotificationPreferences()
        )
    }
    
    // Comprehensive initializer
    init(id: String, email: String, authMethod: AuthMethod, createdAt: Date, lastActive: Date, onboarding: OnboardingState, currentStage: UserStage, accountTier: AccountTier, device: DeviceInfo, notifications: NotificationPreferences) {
        self.id = id
        self.email = email
        self.authMethod = authMethod
        self.createdAt = createdAt
        self.lastActive = lastActive
        self.onboarding = onboarding
        self.currentStage = currentStage
        self.accountTier = accountTier
        self.device = device
        self.notifications = notifications
    }
    
    // Simple initializer for backward compatibility
    init(id: String, email: String, authMethod: AuthMethod) {
        self.id = id
        self.email = email
        self.authMethod = authMethod
        self.createdAt = Date()
        self.lastActive = Date()
        self.onboarding = OnboardingState(totalSteps: 4)
        self.currentStage = .onboarding
        self.accountTier = .freemium
        self.device = DeviceInfo()
        self.notifications = NotificationPreferences()
        self.isTemporary = false
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
    var totalSteps: Int
    
    init(surveyCompleted: Bool = false, completionTimestamp: Date? = nil, currentStep: Int = 1, stepsCompleted: Int = 0, totalSteps: Int = 4) {
        self.surveyCompleted = surveyCompleted
        self.completionTimestamp = completionTimestamp
        self.currentStep = currentStep
        self.stepsCompleted = stepsCompleted
        self.totalSteps = totalSteps
    }
}

// User stage in journey
enum UserStage: String, Codable {
    case onboarding, active, dormant
}

// Module completion tracking
struct ModulesCompleted: Codable {
    var wealth: Int = 0
    var brand: Int = 0
    var lastCompletedTimestamp: Date?
}

// Game session records
struct GameSession: Codable, Identifiable {
    var sessionId: String      // Unique identifier
    var moduleId: String
    var startTime: Date
    var duration: Int          // in seconds
    var score: Int
    var livesUsed: Int?
    var outcome: GameOutcome
    
    var id: String { sessionId }
}

enum GameOutcome: String, Codable {
    case success, fail, incomplete
}

// Retention tracking
struct RetentionMetrics: Codable {
    var streakDays: Int = 0
    var sessionFrequency: Double = 0  // Avg sessions per week
    var day1Retention: Bool = false
    var day7Retention: Bool = false
    var day30Retention: Bool = false
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
    var currentBalance: Int = 0
    var lastEarnedTimestamp: Date?
    var burnRate: Double = 0
    var rewardsRedeemed: [Reward] = []
    
    struct Reward: Codable, Identifiable {
        var rewardId: String
        var type: RewardType
        var pointsCost: Int
        var redeemedAt: Date
        
        var id: String { rewardId }
    }
    
    enum RewardType: String, Codable {
        case merch = "Merch"
        case event = "Event"
        case asset = "Asset"
        case discount = "Discount"
        case featureUnlock = "FeatureUnlock"
    }
}

// Content preference
enum ContentType: String, Codable {
    case story = "Story"
    case tactical = "Tactical"
    case mixed = "Mixed"
    case undetermined = "Undetermined"
}

// Account tier
enum AccountTier: String, Codable {
    case freemium = "Freemium"
    case premium = "Premium"
    case trial = "Trial"
}

// Premium conversion tracking
struct PremiumConversion: Codable {
    var convertedAt: Date
    var trigger: String
    var previousTier: AccountTier
}

// Trial information
struct TrialInfo: Codable {
    var trialStartDate: Date
    var trialEndDate: Date
    var trialType: String
}

// Purchase history
struct Purchase: Codable, Identifiable {
    var purchaseId: String
    var itemId: String
    var itemType: PurchaseType
    var amount: Int        // In smallest currency unit (cents)
    var currency: String   // ISO currency code (e.g. "USD")
    var purchaseTimestamp: Date
    var transactionId: String?
    
    var id: String { purchaseId }
}

// Purchase types
enum PurchaseType: String, Codable {
    case subscription = "Subscription"
    case iap = "IAP"
    case service = "Service"
}

// Device information
struct DeviceInfo: Codable {
    var os: OS
    var osVersion: String
    var appVersion: String
    var lastLoginDevice: String
    
    enum OS: String, Codable {
        case iOS
        case android = "Android"
        case web = "Web"
        case other = "Other"
    }
    
    init() {
        self.os = .iOS  // Default for this app
        self.osVersion = UIDevice.current.systemVersion
        self.appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
        self.lastLoginDevice = UIDevice.current.model
    }
}

// Notification preferences and engagement
struct NotificationPreferences: Codable {
    var pushEnabled: Bool = false
    var emailSubscribed: Bool = false
    var engagement: [NotificationEvent] = []
}

// Notification engagement
struct NotificationEvent: Codable, Identifiable {
    var notificationId: String
    var type: String
    var sentAt: Date
    var openedAt: Date?
    var clickedAt: Date?
    
    var id: String { notificationId }
}

// Learning Goal (Step 3 of onboarding)
enum LearningGoal: String, Codable {
    case wealthBuilding = "Wealth Building"
    case careerBuilding = "Career Building"
    case brandBuilding = "Brand Building"
}

// MARK: - User Extension for Convenience Methods
extension User {
    // Check if user has completed onboarding
    var hasCompletedOnboarding: Bool {
        onboarding.surveyCompleted && onboarding.stepsCompleted >= onboarding.totalSteps
    }
    
    // Update last active timestamp
    mutating func updateActivity() {
        lastActive = Date()
    }
    
    // Updates for onboarding steps
    mutating func updateStep1(athleteType: AthleteType, sport: String, dateOfBirth: String, phoneNumber: String) {
        self.athleteType = athleteType
        self.sport = sport
        
        // Convert date string to age
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let dob = dateFormatter.date(from: dateOfBirth) {
            let now = Date()
            let calendar = Calendar.current
            let ageComponents = calendar.dateComponents([.year], from: dob, to: now)
            self.age = ageComponents.year
        }
        
        // Update onboarding progress
        onboarding.currentStep = 2
        onboarding.stepsCompleted = 1
        updateActivity()
    }
    
    mutating func updateStep2(interests: [Interest]) {
        self.interests = interests
        
        // Update onboarding progress
        onboarding.currentStep = 3
        onboarding.stepsCompleted = 2
        updateActivity()
    }
    
    mutating func updateStep3(learningGoal: LearningGoal) {
        // Set preferred content based on learning goal
        switch learningGoal {
        case .wealthBuilding:
            preferredContentType = .tactical
        case .brandBuilding:
            preferredContentType = .story
        case .careerBuilding:
            preferredContentType = .mixed
        }
        
        // Update onboarding progress
        onboarding.currentStep = 4
        onboarding.stepsCompleted = 3
        updateActivity()
    }
    
    mutating func completeOnboarding() {
        onboarding.surveyCompleted = true
        onboarding.stepsCompleted = onboarding.totalSteps
        onboarding.completionTimestamp = Date()
        currentStage = .active
        updateActivity()
    }
    
    // Utility methods for working with the user model
    func toJSON() -> [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return try? JSONSerialization.jsonObject(with: data) as? [String: Any]
    }
    
    static func fromJSON(_ json: [String: Any]) -> User? {
        guard let data = try? JSONSerialization.data(withJSONObject: json) else { return nil }
        return try? JSONDecoder().decode(User.self, from: data)
    }
}
