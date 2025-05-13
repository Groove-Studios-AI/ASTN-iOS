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
                    var newUser = User.newUser(id: userId, email: email, authMethod: authMethod)
                    
                    // Populate other user fields if available
                    if let onboardingDict = user["onboarding"] as? [String: Any],
                       let surveyCompleted = onboardingDict["surveyCompleted"] as? Bool {
                        newUser.onboarding.surveyCompleted = surveyCompleted
                        newUser.onboarding.completionTimestamp = Date()
                        
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
    
    /// Update user with athlete type, sport, date of birth and phone number (Step 1)
    func updateUserStep1(athleteType: AthleteType, sport: String, dateOfBirth: String, phoneNumber: String, completion: @escaping (Result<User, Error>) -> Void) {
        guard var user = currentUser else {
            completion(.failure(SessionError.noUserLoggedIn))
            return
        }
        
        // Use the new updateStep1 method
        user.updateStep1(athleteType: athleteType, sport: sport, dateOfBirth: dateOfBirth, phoneNumber: phoneNumber)
        
        // Store phone number in UserDefaults (not part of core model but needed for password retrieval)
        UserDefaults.standard.set(phoneNumber, forKey: "userPhoneNumber")
        
        // Update current user
        currentUser = user
        
        // Prepare data for API
        let updateData: [String: Any] = [
            "athleteType": athleteType.rawValue, 
            "sport": sport,
            "dateOfBirth": dateOfBirth,
            "phoneNumber": phoneNumber,
            "age": user.age as Any,
            "onboarding": ["currentStep": user.onboarding.currentStep, 
                          "stepsCompleted": user.onboarding.stepsCompleted]
        ]
        
        // Send update to API
        apiService.updateUser(userId: user.id, data: updateData, token: authToken) { [weak self] result in
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
        
        // Use the new updateStep2 method
        user.updateStep2(interests: interests)
        
        // Update current user
        currentUser = user
        
        // Prepare data for API
        let interestValues = interests.map { $0.rawValue }
        let updateData: [String: Any] = [
            "interests": interestValues,
            "onboarding": ["currentStep": user.onboarding.currentStep, 
                          "stepsCompleted": user.onboarding.stepsCompleted]
        ]
        
        // Send update to API
        apiService.updateUser(userId: user.id, data: updateData, token: authToken) { [weak self] result in
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
        
        // Use the new updateStep3 method
        user.updateStep3(learningGoal: learningGoal)
        
        // Also update mindset profile based on learning goal
        user.mindsetProfile = getMindsetFromLearningGoal(learningGoal)
        
        // Update current user
        currentUser = user
        
        // Not completing onboarding yet - still need profile picture step
        
        // Prepare data for API
        let updateData: [String: Any] = [
            "mindsetProfile": user.mindsetProfile?.rawValue as Any,
            "learningGoal": learningGoal.rawValue,
            "preferredContentType": user.preferredContentType?.rawValue as Any,
            "onboarding": [
                "currentStep": user.onboarding.currentStep,
                "stepsCompleted": user.onboarding.stepsCompleted
            ]
        ]
        
        // Send update to API
        apiService.updateUser(userId: user.id, data: updateData, token: authToken) { [weak self] result in
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
    
    // MARK: - Profile Picture Methods
    
    /// Update user with profile picture
    func updateUserProfilePicture(imageData: Data, completion: @escaping (Result<User, Error>) -> Void) {
        guard var user = currentUser else {
            completion(.failure(SessionError.noUserLoggedIn))
            return
        }
        
        // Complete the onboarding process
        user.completeOnboarding()
        currentUser = user
        
        // Onboarding is now complete
        isOnboarding = false
        
        // Prepare onboarding completion data
        let updateData: [String: Any] = [
            "onboarding": [
                "surveyCompleted": true,
                "completionTimestamp": ISO8601DateFormatter().string(from: user.onboarding.completionTimestamp ?? Date()),
                "stepsCompleted": user.onboarding.totalSteps
            ],
            "currentStage": user.currentStage.rawValue
        ]
        
        // Send update to API
        apiService.uploadProfilePicture(userId: user.id, imageData: imageData, token: authToken) { [weak self] pictureResult in
            switch pictureResult {
            case .success(_):
                // After successful picture upload, update the onboarding status
                self?.apiService.updateUser(userId: user.id, data: updateData, token: self?.authToken) { finalResult in
                    switch finalResult {
                    case .success(_):
                        // Everything successful
                        self?.saveSession(user: user, token: self?.authToken)
                        completion(.success(user))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    /// Skip profile picture upload and complete onboarding
    func skipProfilePicture(completion: @escaping (Result<User, Error>) -> Void) {
        guard var user = currentUser else {
            completion(.failure(SessionError.noUserLoggedIn))
            return
        }
        
        // Complete the onboarding process
        user.completeOnboarding()
        currentUser = user
        
        // Onboarding is now complete
        isOnboarding = false
        
        // Prepare data for API
        let updateData: [String: Any] = [
            "onboarding": [
                "surveyCompleted": true,
                "completionTimestamp": ISO8601DateFormatter().string(from: user.onboarding.completionTimestamp ?? Date()),
                "stepsCompleted": user.onboarding.totalSteps
            ],
            "currentStage": user.currentStage.rawValue
        ]
        
        // Send update to API
        apiService.updateUser(userId: user.id, data: updateData, token: authToken) { [weak self] result in
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
    
    func uploadProfilePicture(userId: String, imageData: Data, token: String?, completion: @escaping (Result<[String: Any], Error>) -> Void) {
        // Validate token
        guard token != nil else {
            completion(.failure(SessionError.sessionExpired))
            return
        }
        
        // Simulate network delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            // Mock successful response with image URL
            let imageUrl = "https://api.astn.app/users/\(userId)/profile-picture.jpg"
            completion(.success(["url": imageUrl]))
        }
    }
    
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
