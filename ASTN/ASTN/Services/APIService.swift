import Foundation
import Amplify

/// Custom errors for API and session-related operations
enum SessionError: Error {
    case noUserLoggedIn
    case invalidUserData
    case networkError
    case sessionExpired
    case confirmationRequired
    case confirmationFailed
    case authenticationFailed
    case userNotFound
    case userAlreadyExists
    case signUpFailed
    case signInFailed
    case unknown
}

/// Service for handling API requests to the backend
class APIService {
    
    // MARK: - User API Methods
    
    /// Upload a profile picture
    /// - Parameters:
    ///   - userId: The user's ID
    ///   - imageData: Binary image data
    ///   - token: Optional auth token
    ///   - completion: Completion handler
    func uploadProfilePicture(userId: String, imageData: Data, token: String?, completion: @escaping (Result<[String: Any], Error>) -> Void) {
        // Validate token
        guard token != nil else {
            completion(.failure(SessionError.sessionExpired))
            return
        }
        
        print("📡 Uploading profile picture for user \(userId) - \(imageData.count) bytes")
        
        // Simulate network delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            // Mock successful response with image URL
            let imageUrl = "https://api.astn.app/users/\(userId)/profile-picture.jpg"
            completion(.success(["url": imageUrl]))
        }
    }
    
    /// Register a new user
    /// - Parameters:
    ///   - email: User's email
    ///   - password: User's password
    ///   - completion: Completion handler
    func registerUser(email: String, password: String, completion: @escaping (Result<[String: Any], Error>) -> Void) {
        print("📡 Registering user with email: \(email)")
        
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
    
    /// Login an existing user
    /// - Parameters:
    ///   - email: User's email
    ///   - password: User's password
    ///   - completion: Completion handler
    func login(email: String, password: String, completion: @escaping (Result<[String: Any], Error>) -> Void) {
        print("📡 Logging in user with email: \(email)")
        
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
    
    /// Update a user's profile
    /// - Parameters:
    ///   - userId: The user's ID
    ///   - data: Dictionary of data to update
    ///   - token: Optional auth token
    ///   - completion: Completion handler
    func updateUser(userId: String, data: [String: Any], token: String?, completion: @escaping (Result<[String: Any], Error>) -> Void) {
        // Validate token
        guard token != nil else {
            completion(.failure(SessionError.sessionExpired))
            return
        }
        
        print("📡 Updating user \(userId) with data: \(data)")
        
        // Simulate network delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            // Mock successful response
            completion(.success(["success": true]))
        }
    }
}
