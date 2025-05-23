import Foundation
import Combine
import Amplify
import AWSCognitoAuthPlugin
import AWSAPIPlugin
// Ensure we can access SessionError from APIService
// No need for extra imports in the same module

// Helper bridge for migrating from callbacks to async/await
extension Amplify {
    struct Legacy {
        static func wrap<T>(_ work: @escaping () async throws -> T,
                           completion: @escaping (Result<T,Error>) -> Void) {
            Task {
                do   { completion(.success(try await work())) }
                catch { completion(.failure(error)) }
            }
        }
    }
}

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
        // Make sure Amplify is configured first (safe: returns immediately if already done)
        AmplifyConfigAsync.configure()
        
        // Check for existing auth session on init
        checkForExistingSession()
        
        // Setup auth event listener
        setupAuthEventListener()
    }
    
    // Listen for Amplify auth events
    private func setupAuthEventListener() {
        _ = Amplify.Hub.listen(to: .auth) { [weak self] (payload: HubPayload) in
            switch payload.eventName {
            case HubPayload.EventName.Auth.signedIn:
                print("✓ User signed in - updating UserSession")
                self?.fetchCurrentAuthSession()
                
            case HubPayload.EventName.Auth.signedOut:
                print("✓ User signed out - clearing UserSession")
                DispatchQueue.main.async {
                    self?.currentUser = nil
                    self?.isAuthenticated = false
                    self?.clearStoredSession()
                }
                
            case HubPayload.EventName.Auth.sessionExpired:
                print("⚠️ Session expired")
                DispatchQueue.main.async {
                    self?.isAuthenticated = false
                }
                
            default:
                break
            }
        }
    }
    
    // MARK: - Authentication Methods
    
    /// Register a new user with email and password
    /// Async implementation for registration
    private func registerUserAsync(email: String, password: String, name: String) async throws -> User {
        let userAttributes = [
            AuthUserAttribute(.email, value: email),
            AuthUserAttribute(.name, value: name)
        ]
        let options = AuthSignUpRequest.Options(userAttributes: userAttributes)
        
        let signUpResult = try await Amplify.Auth.signUp(
            username: email,
            password: password,
            options: options)
        
        guard signUpResult.isSignUpComplete else {
            print("⚠️ Sign up needs confirmation")
            throw SessionError.confirmationRequired
        }
        
        print("✅ Sign up successful - user confirmed automatically")
        // Set name in new user after login
        var user = try await loginAsync(email: email, password: password)
        user.name = name
        return user
    }
    
    // Legacy wrapper for backward compatibility
    func registerUser(email: String, password: String, name: String, completion: @escaping (Result<User, Error>) -> Void) {
        Amplify.Legacy.wrap({ [weak self] in
            guard let self = self else { throw SessionError.unknown }
            return try await self.registerUserAsync(email: email, password: password, name: name)
        }, completion: completion)
    }
    
    /// Async implementation of confirmation signup
    private func confirmSignUpAsync(username: String, confirmationCode: String) async throws -> Bool {
        do {
            _ = try await Amplify.Auth.confirmSignUp(
                for: username,
                confirmationCode: confirmationCode
            )
            print("✅ Confirmation successful")
            return true
        } catch {
            print("❌ Confirmation failed: \(error)")
            throw SessionError.confirmationFailed
        }
    }
    
    /// Confirm user signup with confirmation code - legacy wrapper
    func confirmSignUp(username: String, confirmationCode: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        Amplify.Legacy.wrap({ [weak self] in
            guard let self = self else { throw SessionError.unknown }
            return try await self.confirmSignUpAsync(username: username, confirmationCode: confirmationCode)
        }, completion: completion)
    }
    
    /// Async implementation for login
    private func loginAsync(email: String, password: String) async throws -> User {
        let signInResult = try await Amplify.Auth.signIn(username: email, password: password)
        
        if signInResult.isSignedIn {
            print("✅ Sign in successful")
            
            // Get user ID from authentication session
            guard let userId = try? await AmplifyConfigAsync.getCurrentUserId() else {
                throw SessionError.noUserLoggedIn
            }
            
            // Create basic user initially
            let newUser = User.newUser(id: userId, email: email, authMethod: .email)
            
            // Update UI state
            await MainActor.run {
                self.currentUser = newUser
                self.isAuthenticated = true
                self.isOnboarding = true  // Assume new user starts onboarding by default
            }
            
            // Now query GraphQL to check if this user has a profile
            do {
                let hasProfile = try await fetchUserProfileAsync(userId: userId)
                await MainActor.run {
                    self.isOnboarding = !hasProfile
                }
            } catch {
                print("⚠️ Could not fetch user profile: \(error)")
            }
            
            saveSession(user: newUser, token: nil)
            return newUser
            
        } else if case .confirmSignUp = signInResult.nextStep {
            // User needs to confirm sign up
            throw SessionError.confirmationRequired
        } else {
            // Need to handle other next steps (password reset, etc.)
            throw SessionError.authenticationFailed
        }
    }
    
    /// Legacy wrapper for login
    func login(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        Amplify.Legacy.wrap({ [weak self] in
            guard let self = self else { throw SessionError.unknown }
            return try await self.loginAsync(email: email, password: password)
        }, completion: completion)
    }
    
    /// Async implementation of logout
    private func logoutAsync() async {
        // First, verify current auth status to prevent edge cases
        do {
            let session = try await Amplify.Auth.fetchAuthSession()
            if !session.isSignedIn {
                print("⚠️ No user is currently signed in")
            }
        } catch {
            print("❌ Error checking auth session before logout: \(error)")
        }
        
        // Call the sign out function
        _ = await AmplifyConfigAsync.signOut()
        
        // Force clear the Amplify auth plugin's cached tokens
        try? await Task.sleep(nanoseconds: 500_000_000) // Wait 500ms to ensure AWS operations complete
        
        // Verify sign out was successful
        do {
            let session = try await Amplify.Auth.fetchAuthSession()
            if session.isSignedIn {
                print("⚠️ Warning: User is still signed in after logout attempt!")
                // Try one more time with a different approach
                _ = await forceSignOut()
            } else {
                print("✅ Successfully verified user is signed out")
            }
        } catch {
            print("❌ Error verifying sign out: \(error)")
        }
        
        // Update UI on main thread
        await MainActor.run {
            // Clear local state
            currentUser = nil
            authToken = nil
            isAuthenticated = false
            isOnboarding = false
        }
        
        clearStoredSession()
        
        // Notify the AppCoordinator to return to login screen
        await MainActor.run {
            AppCoordinator.shared.switchToLoginFlow()
        }
    }
    
    /// Force sign out as a fallback method
    private func forceSignOut() async -> AuthSignOutResult {
        print("🔄 Attempting force sign out...")
        // Different sign out approach as fallback
        return await Amplify.Auth.signOut(options: .init(globalSignOut: false))
    }
    
    /// Logout the current user (legacy wrapper)
    func logout(completion: (() -> Void)? = nil) {
        Task { [weak self] in
            await self?.logoutAsync()
            // Call completion handler on main thread if provided
            if let completion = completion {
                await MainActor.run {
                    completion()
                }
            }
        }
    }
    
    /// Async implementation of fetchCurrentAuthSession
    private func fetchCurrentAuthSessionAsync() async {
        do {
            let session = try await Amplify.Auth.fetchAuthSession()
            
            // Update authentication state
            await MainActor.run {
                self.isAuthenticated = session.isSignedIn
            }
            
            if session.isSignedIn {
                // If authenticated, get the user ID
                guard let userId = await AmplifyConfigAsync.getCurrentUserId() else { return }
                
                // Try to load user from local storage first
                if let storedUser = loadUserFromStorage(), storedUser.id == userId {
                    await MainActor.run {
                        self.currentUser = storedUser
                    }
                } else {
                    // Otherwise create a basic user object and fetch details later
                    let newUser = User.newUser(id: userId, email: "", authMethod: .email)
                    
                    await MainActor.run {
                        self.currentUser = newUser
                    }
                    
                    // Try to fetch user profile to determine if onboarding is needed
                    do {
                        let hasProfile = try await fetchUserProfileAsync(userId: userId)
                        await MainActor.run {
                            self.isOnboarding = !hasProfile
                        }
                    } catch {
                        print("⚠️ Could not fetch user profile: \(error)")
                    }
                }
            }
        } catch {
            print("❌ Failed to get auth session: \(error)")
            await MainActor.run {
                self.isAuthenticated = false
                self.currentUser = nil
            }
        }
    }
    
    /// Legacy wrapper for fetchCurrentAuthSession
    func fetchCurrentAuthSession() {
        Task { [weak self] in
            await self?.fetchCurrentAuthSessionAsync()
        }
    }
    
    /// Async implementation of fetchUserProfile
    private func fetchUserProfileAsync(userId: String) async throws -> Bool {
        // Use Amplify GraphQL API to fetch the user profile
        // This is a placeholder - you'll need to implement the actual GraphQL query
        
        // For now, just return true if the user exists in the local storage
        if let storedUser = loadUserFromStorage(), storedUser.id == userId {
            return true
        } else {
            // In a real implementation, you'd query the backend asynchronously
            return false
        }
    }
    
    /// Legacy wrapper for fetchUserProfile
    private func fetchUserProfile(userId: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        Amplify.Legacy.wrap({ [weak self] in
            guard let self = self else { throw SessionError.unknown }
            return try await self.fetchUserProfileAsync(userId: userId)
        }, completion: completion)
    }
    
    // MARK: - Cognito User Attributes
    
    // MARK: - Cognito User Attributes Methods
    // Moved to UserSession+CognitoAttributes.swift extension
    
    // MARK: - User Creation Helpers
    
    /// Creates a temporary user if the currentUser is nil
    /// This is a fallback mechanism to ensure the onboarding flow can continue
    /// even if there are issues with the user object after signup/confirmation
    func createTemporaryUserIfNeeded() {
        if currentUser == nil {
            print("ℹ️ Creating temporary user for onboarding")
            // Generate a UUID for the user
            let userId = UUID().uuidString
            
            // Create a basic user with minimal information
            // Using the temporary email will help us identify these users
            var tempUser = User.newUser(
                id: userId,
                email: "temporary_\(userId)@example.com",
                authMethod: .email
            )
            
            // Mark this user as temporary to avoid Cognito operations
            tempUser.isTemporary = true
            
            // Update the current user
            currentUser = tempUser
            isAuthenticated = true
            isOnboarding = true
            print("✅ Temporary user created with ID: \(userId)")
            
            // Save the temporary user to UserDefaults
            saveSession(user: tempUser, token: nil)
        }
    }
    
    /// Checks if the current user is a temporary user
    func isTemporaryUser() -> Bool {
        return currentUser?.isTemporary == true || (currentUser?.email.starts(with: "temporary_") == true)
    }
    
    // MARK: - Onboarding Methods
    
    /// Update user with athlete type, sport, date of birth and phone number (Step 1)
    func updateUserStep1(athleteType: AthleteType, sport: String, dateOfBirth: String, phoneNumber: String, completion: @escaping (Result<User, Error>) -> Void) {
        // First ensure we have a user object to work with
        if currentUser == nil {
            print("⚠️ No user found in updateUserStep1, creating temporary user")
            createTemporaryUserIfNeeded()
        }
        
        guard var user = currentUser else {
            print("❌ Still no user after createTemporaryUserIfNeeded() - this is a critical error")
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
    
    private func clearStoredSession() {
        UserDefaults.standard.removeObject(forKey: "currentUser")
        UserDefaults.standard.removeObject(forKey: "authToken")
    }
    
    private func loadUserFromStorage() -> User? {
        guard let userData = UserDefaults.standard.data(forKey: "currentUser") else {
            return nil
        }
        
        do {
            let user = try JSONDecoder().decode(User.self, from: userData)
            return user
        } catch {
            print("Error loading user from storage: \(error)")
            return nil
        }
    }
    
    /// Restore user session from both Amplify and local storage
    /// This method is designed to be called during app startup to enable auto-login
    func restoreUserSession() async {
        print("🔄 Attempting to restore user session...")
        
        do {
            // 1. Check if Amplify says we're signed in
            let session = try await Amplify.Auth.fetchAuthSession()
            let isSignedIn = session.isSignedIn
            
            if !isSignedIn {
                print("⚠️ Amplify reports no active auth session")
                await MainActor.run {
                    self.isAuthenticated = false
                    self.currentUser = nil
                }
                return
            }
            
            // 2. Get Cognito user attributes
            let attributes = try await Amplify.Auth.fetchUserAttributes()
            print("✅ Retrieved \(attributes.count) user attributes from Cognito")
            
            // 3. Get current Cognito user ID
            guard let userId = await AmplifyConfigAsync.getCurrentUserId() else {
                print("⚠️ Could not retrieve user ID from Amplify")
                return
            }
            
            // 4. Try to load user from local storage first
            var user = self.loadUserFromStorage()
            
            // 5. Verify user ID matches or create new user object
            if user == nil || user?.id != userId {
                // Create a basic user from Cognito data
                print("ℹ️ Creating new user object from Cognito data")
                var createdUser = User.newUser(
                    id:    userId,
                    email: attributes.first(where: { $0.key == .email })?.value ?? "",
                    authMethod: .email                       // mandatory parameter
                )
                
                // Fill any optional profile data you want to keep
                createdUser.name = attributes.first(where: { $0.key == .name })?.value ?? ""
                createdUser.onboarding.surveyCompleted = true     // mark survey done
                // createdUser.profilePicture = nil  // already nil by default
                
                user = createdUser
            }
            
            if let user = user {
                // Update UI on main thread
                await MainActor.run {
                    self.currentUser = user
                    self.isAuthenticated = true
                    self.isOnboarding = !user.onboarding.surveyCompleted
                    
                    // Re-save the user to ensure it's current
                    self.saveSession(user: user, token: nil)
                }
                print("✅ Successfully restored user session for: \(user.id)")
            }
        } catch {
            print("❌ Error restoring user session: \(error)")
            await MainActor.run {
                self.isAuthenticated = false
                self.currentUser = nil
            }
        }
    }
    
    // Check if there's a saved session
    private func checkForExistingSession() {
        // Check Amplify auth session first
        fetchCurrentAuthSession()
        
        // As a fallback, check local storage
        if !isAuthenticated, let userData = UserDefaults.standard.data(forKey: "currentUser"),
           let user = try? JSONDecoder().decode(User.self, from: userData) {
            
            // We have a stored user but need to verify with Amplify
            Task {
                let isSignedIn = await AmplifyConfigAsync.isSignedIn()
                await MainActor.run {
                    self.isAuthenticated = isSignedIn
                    if isSignedIn {
                        self.currentUser = user
                        self.isOnboarding = !user.onboarding.surveyCompleted
                    } else {
                        // Auth expired, clear local session
                        self.clearStoredSession()
                    }
                }
            }
        }
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

// Import SessionError from APIService
