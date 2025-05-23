import Foundation
import Amplify
import AWSCognitoAuthPlugin
import AWSAPIPlugin

struct AmplifyConfigAsync {
    
    private static var isConfigured = false          // <─ guard flag
    
    /// Configure Amplify with the required plugins
    static func configure() {
        guard !isConfigured else { return }          // already done
        
        do {
            // add only the plugins you actually use
            try Amplify.add(plugin: AWSCognitoAuthPlugin())
            try Amplify.add(plugin: AWSAPIPlugin())
            
            try Amplify.configure()
            isConfigured = true
            print("✅ Amplify configured successfully")
        } catch {
            print("❌ Amplify configure error:", error)
        }
    }

    /// Current Cognito `sub` (user id) or `nil` if signed-out
    static func getCurrentUserId() async -> String? {
        do {
            // 1. quick check – are we even signed-in?
            let authSession = try await Amplify.Auth.fetchAuthSession()
            guard authSession.isSignedIn else { return nil }

            // 2. fetch user attributes and pull the `sub`
            let attrs = try await Amplify.Auth.fetchUserAttributes()
            return attrs.first(where: { $0.key == .sub })?.value
        } catch {
            print("❌ getCurrentUserId error:", error)
            return nil
        }
    }

    static func isSignedIn() async -> Bool {
        (try? await Amplify.Auth.fetchAuthSession().isSignedIn) ?? false
    }

    /// Global sign-out (all devices)
    static func signOut() async {
        // ➊ this API is non-throwing in v2
        let result: any AuthSignOutResult = await Amplify.Auth.signOut(
            options: .init(globalSignOut: true))

        // ➋ down-cast to the Cognito concrete type so we can pattern-match
        guard let cognito = result as? AWSCognitoSignOutResult else {
            print("⚠️ Unknown sign-out result:", result)
            return
        }

        switch cognito {
        case .complete:
            print("✅ Signed out everywhere")

        case .partial(let revokeError,
                      let globalError,
                      let hostedUIError):
            print("⚠️ Partial sign-out\n  revoke: \(String(describing: revokeError))\n  global: \(String(describing: globalError))\n  hostedUI: \(String(describing: hostedUIError))")

        case .failed(let error):
            print("❌ Sign-out failed:", error)
        }
    }
}
