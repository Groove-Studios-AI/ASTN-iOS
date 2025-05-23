import Foundation
import Amplify
import AWSCognitoAuthPlugin

// Helper method from main class that we need access to in this extension
extension MindsetProfile {
    static func fromLearningGoal(_ goal: LearningGoal) -> MindsetProfile {
        switch goal {
        case .wealthBuilding:
            return .security
        case .careerBuilding:
            return .growth
        case .brandBuilding:
            return .legacy
        }
    }
}

// Extension to UserSession for handling Cognito attribute updates
extension UserSession {
    
    // MARK: - Cognito Attribute Management
    
    /// Updates Cognito attributes for step 1 of onboarding
    func updateCognitoStep1Attributes(athleteType: AthleteType, sport: String, dateOfBirth: String, phoneNumber: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        let attributes: [String: String] = [
            "custom:athleteType": athleteType.rawValue,
            "custom:sport": sport, 
            "custom:dateOfBirth": dateOfBirth,
            "phone_number": phoneNumber
        ]
        
        updateCognitoUserAttributes(attributes, completion: completion)
    }
    
    /// Updates Cognito attributes for step 2 of onboarding
    func updateCognitoStep2Attributes(interests: [Interest], completion: @escaping (Result<Bool, Error>) -> Void) {
        // Serialize interests to a JSON string for storage
        let interestStrings = interests.map { $0.rawValue }
        if let interestsJson = try? JSONSerialization.data(withJSONObject: interestStrings),
           let interestsString = String(data: interestsJson, encoding: .utf8) {
            
            let attributes: [String: String] = [
                "custom:interests": interestsString
            ]
            
            updateCognitoUserAttributes(attributes, completion: completion)
        } else {
            print("⚠️ Failed to serialize interests to JSON")
            completion(.success(false))
        }
    }
    
    /// Updates Cognito attributes for step 3 of onboarding
    func updateCognitoStep3Attributes(learningGoal: LearningGoal, completion: @escaping (Result<Bool, Error>) -> Void) {
        let attributes: [String: String] = [
            "custom:learningGoal": learningGoal.rawValue,
            "custom:mindsetProfile": MindsetProfile.fromLearningGoal(learningGoal).rawValue
        ]
        
        updateCognitoUserAttributes(attributes, completion: completion)
    }
    
    /// Updates Cognito user attributes
    /// - Parameters:
    ///   - attributes: Dictionary of attribute names and values
    ///   - completion: Completion handler with success/failure result
    internal func updateCognitoUserAttributes(
        _ attributes: [String: String],
        completion: @escaping (Result<Bool, Error>) -> Void
    ) {
        print("ℹ️ Updating Cognito attributes: \(attributes)")

        var userAttributes: [AuthUserAttribute] = []

        for (key, value) in attributes {
            if key.hasPrefix("custom:") {                // custom attribute
                let customAttr = AuthUserAttributeKey(rawValue: key)
                userAttributes.append(AuthUserAttribute(customAttr, value: value))
            } else {                                     // standard attribute
                let authKey = AuthUserAttributeKey(rawValue: key)
                userAttributes.append(AuthUserAttribute(authKey, value: value))
            }
        }

        guard !userAttributes.isEmpty else {
            print("⚠️ No valid attributes to update")
            completion(.success(false))
            return
        }

        Task {
            do {
                let result = try await Amplify.Auth.update(userAttributes: userAttributes)
                await MainActor.run {
                    if result.isEmpty {
                        print("✅ All Cognito attributes updated")
                    } else {
                        print("⚠️ These attributes need confirmation: \(result)")
                    }
                    completion(.success(true))
                }
            } catch {
                await MainActor.run {
                    print("❌ Failed to update Cognito attributes: \(error)")
                    completion(.failure(error))
                }
            }
        }
    }
}
