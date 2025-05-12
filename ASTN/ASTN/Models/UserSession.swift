import Foundation
import Combine

class UserSession: ObservableObject {
    // Singleton instance for app-wide access
    static let shared = UserSession()
    
    // Published properties to react to auth state changes
    @Published var currentUser: User?
    @Published var isAuthenticated: Bool = false
    @Published var isOnboarding: Bool = false
    
    // API service for networking
    private let apiService = APIService()
    
    // Auth token for API requests
    private var authToken: String?
    
    private init() {
        // Check for existing auth session on init
        checkForExistingSession()
    }
    
    // MARK: - Authentication Methods
    
    /// Register a new user with email and password
    func registerUser(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        // Simulate API call for now
        apiService.registerUser(email: email, password: password) { [weak self] result in
            switch result {
            case .success(let userData):
                // Create user from API response
                if let user = userData["user"] as? [String: Any], 
                   let userId = user["id"] as? String,
                   let email = user["email"] as? String,
                   let authMethodStr = user["authMethod"] as? String,
                   let authMethod = AuthMethod(rawValue: authMethodStr) {
                    
                    // Create user and store token
                    let newUser = User(id: userId, email: email, authMethod: authMethod)
                    self?.currentUser = newUser
                    self?.isAuthenticated = true
                    self?.isOnboarding = true
                    
                    // Store auth token
                    if let token = userData["token"] as? String {
                        self?.authToken = token
                        self?.saveSession(user: newUser, token: token)
                    }
                    
                    completion(.success(newUser))
                } else {
                    completion(.failure(SessionError.invalidUserData))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    /// Login with email and password
    func login(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        apiService.login(email: email, password: password) { [weak self] result in
            switch result {
            case .success(let userData):
                // Parse user data and store session
                if let user = userData["user"] as? [String: Any], 
                   let userId = user["id"] as? String,
                   let email = user["email"] as? String,
                   let authMethodStr = user["authMethod"] as? String,
                   let authMethod = AuthMethod(rawValue: authMethodStr) {
                    
                    // Create a user from the response
                    var newUser = User(id: userId, email: email, authMethod: authMethod)
                    
                    // Populate other user fields if available
                    if let onboardingDict = user["onboarding"] as? [String: Any],
                       let surveyCompleted = onboardingDict["surveyCompleted"] as? Bool {
                        var onboarding = OnboardingState()
                        onboarding.surveyCompleted = surveyCompleted
                        newUser.onboarding = onboarding
                        
                        // If onboarding is complete, we should go straight to the main app
                        self?.isOnboarding = !surveyCompleted
                    }
                    
                    self?.currentUser = newUser
                    self?.isAuthenticated = true
                    
                    // Store auth token
                    if let token = userData["token"] as? String {
                        self?.authToken = token
                        self?.saveSession(user: newUser, token: token)
                    }
                    
                    completion(.success(newUser))
                } else {
                    completion(.failure(SessionError.invalidUserData))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    /// Logout the current user
    func logout() {
        currentUser = nil
        authToken = nil
        isAuthenticated = false
        isOnboarding = false
        clearStoredSession()
    }
    
    // MARK: - Onboarding Methods
    
    /// Update user with athlete type and sport (Step 1)
    func updateUserStep1(athleteType: AthleteType, sport: String, completion: @escaping (Result<User, Error>) -> Void) {
        guard var user = currentUser else {
            completion(.failure(SessionError.noUserLoggedIn))
            return
        }
        
        // Update local user data first
        user.athleteType = athleteType
        user.sport = sport
        user.onboarding.currentStep = 2
        user.onboarding.stepsCompleted = 1
        currentUser = user
        
        // Send update to API
        apiService.updateUser(userId: user.id, data: ["athleteType": athleteType.rawValue, 
                                                     "sport": sport,
                                                     "onboarding": ["currentStep": 2, "stepsCompleted": 1]],
                              token: authToken) { [weak self] result in
            switch result {
            case .success(_):
                // Update successful
                self?.saveSession(user: user, token: self?.authToken)
                completion(.success(user))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    /// Update user with interests (Step 2)
    func updateUserStep2(interests: [Interest], completion: @escaping (Result<User, Error>) -> Void) {
        guard var user = currentUser else {
            completion(.failure(SessionError.noUserLoggedIn))
            return
        }
        
        // Update local user data first
        user.interests = interests
        user.onboarding.currentStep = 3
        user.onboarding.stepsCompleted = 2
        currentUser = user
        
        // Convert interests to raw values for API
        let interestStrings = interests.map { $0.rawValue }
        
        // Send update to API
        apiService.updateUser(userId: user.id, 
                              data: ["interests": interestStrings,
                                    "onboarding": ["currentStep": 3, "stepsCompleted": 2]],
                              token: authToken) { [weak self] result in
            switch result {
            case .success(_):
                // Update successful
                self?.saveSession(user: user, token: self?.authToken)
                completion(.success(user))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    /// Update user with learning goal (Step 3)
    func updateUserStep3(learningGoal: LearningGoal, completion: @escaping (Result<User, Error>) -> Void) {
        guard var user = currentUser else {
            completion(.failure(SessionError.noUserLoggedIn))
            return
        }
        
        // Update local user data first
        user.mindsetProfile = getMindsetFromLearningGoal(learningGoal)
        user.onboarding.currentStep = 4 // Completed all steps
        user.onboarding.stepsCompleted = 3
        user.onboarding.surveyCompleted = true
        user.onboarding.completionTimestamp = Date()
        currentUser = user
        
        // Onboarding is now complete
        isOnboarding = false
        
        // Send update to API
        apiService.updateUser(userId: user.id, 
                              data: ["mindsetProfile": getMindsetFromLearningGoal(learningGoal).rawValue,
                                    "onboarding": [
                                        "currentStep": 4,
                                        "stepsCompleted": 3,
                                        "surveyCompleted": true,
                                        "completionTimestamp": Date().timeIntervalSince1970
                                    ]],
                              token: authToken) { [weak self] result in
            switch result {
            case .success(_):
                // Update successful
                self?.saveSession(user: user, token: self?.authToken)
                completion(.success(user))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // Helper to map learning goal to mindset profile
    private func getMindsetFromLearningGoal(_ goal: LearningGoal) -> MindsetProfile {
        switch goal {
        case .wealthBuilding:
            return .security
        case .careerBuilding:
            return .growth
        case .brandBuilding:
            return .legacy
        }
    }
    
    // MARK: - Session Persistence Methods
    
    private func saveSession(user: User, token: String?) {
        // Convert user to data
        if let userData = try? JSONEncoder().encode(user) {
            UserDefaults.standard.set(userData, forKey: "currentUser")
        }
        
        // Save token
        if let token = token {
            UserDefaults.standard.set(token, forKey: "authToken")
        }
    }
    
    private func checkForExistingSession() {
        // Check UserDefaults for stored session
        if let userData = UserDefaults.standard.data(forKey: "currentUser"),
           let storedToken = UserDefaults.standard.string(forKey: "authToken") {
            do {
                let user = try JSONDecoder().decode(User.self, from: userData)
                self.currentUser = user
                self.authToken = storedToken
                self.isAuthenticated = true
                
                // Determine if still in onboarding
                self.isOnboarding = !(user.onboarding.surveyCompleted)
            } catch {
                print("Failed to decode stored user: \(error)")
                clearStoredSession()
            }
        }
    }
    
    private func clearStoredSession() {
        UserDefaults.standard.removeObject(forKey: "currentUser")
        UserDefaults.standard.removeObject(forKey: "authToken")
    }
}

// Custom errors
enum SessionError: Error {
    case noUserLoggedIn
    case invalidUserData
    case networkError
    case sessionExpired
}

// Simplified API service (mock implementation)
class APIService {
    func registerUser(email: String, password: String, completion: @escaping (Result<[String: Any], Error>) -> Void) {
        // Simulate network delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            // Mock successful response
            let userId = UUID().uuidString
            let token = "jwt-token-\(UUID().uuidString)"
            
            let response: [String: Any] = [
                "user": [
                    "id": userId,
                    "email": email,
                    "authMethod": "email",
                    "createdAt": Date().timeIntervalSince1970
                ],
                "token": token
            ]
            
            completion(.success(response))
        }
    }
    
    func login(email: String, password: String, completion: @escaping (Result<[String: Any], Error>) -> Void) {
        // Simulate network delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            // Mock successful response
            let userId = UUID().uuidString
            let token = "jwt-token-\(UUID().uuidString)"
            
            let response: [String: Any] = [
                "user": [
                    "id": userId,
                    "email": email,
                    "authMethod": "email",
                    "createdAt": Date().timeIntervalSince1970,
                    "onboarding": ["surveyCompleted": false]
                ],
                "token": token
            ]
            
            completion(.success(response))
        }
    }
    
    func updateUser(userId: String, data: [String: Any], token: String?, completion: @escaping (Result<[String: Any], Error>) -> Void) {
        // Validate token
        guard token != nil else {
            completion(.failure(SessionError.sessionExpired))
            return
        }
        
        // Simulate network delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            // Mock successful response
            completion(.success(["success": true]))
        }
    }
}
