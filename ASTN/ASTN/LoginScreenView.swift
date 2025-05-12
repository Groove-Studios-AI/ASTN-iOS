import SwiftUI
import UIKit
import Combine

struct LoginScreenView: View {
    // Define brand colors
    private let brandBlack = Color.fromHex("#0A0A0A")
    private let brandBlue = Color.fromHex("#1A2196")
    private let errorRed = Color.red.opacity(0.8)
    
    // State variables for form fields
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isPasswordVisible: Bool = false
    
    // Validation states
    @State private var emailError: String? = nil
    @State private var passwordError: String? = nil
    @State private var showAuthError: Bool = false
    @State private var authErrorMessage: String = ""
    @State private var isLoading: Bool = false
    
    // Computed properties for validation
    private var isEmailValid: Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    private var isPasswordValid: Bool {
        return password.count >= 6
    }
    
    private var isFormValid: Bool {
        return isEmailValid && isPasswordValid
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background color
                brandBlack.ignoresSafeArea(.all)
                
                ScrollView {
                    VStack(spacing: 0) {
                        // Logo - using ASTN_LaunchLogo with exact dimensions
                        Image("ASTN_LaunchLogo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 253, height: 118)
                            .padding(.top, 40)
                            .padding(.bottom, 30)
                            .frame(maxWidth: .infinity, alignment: .center)
                        
                        // Login Header
                        Text("Login")
                            .font(.custom("Magistral", size: 24))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.bottom, 30)
                        
                        // Email Field
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Email")
                                .font(.custom("Magistral", size: 14))
                                .foregroundColor(.white)
                            
                            TextField("", text: $email)
                                .font(.custom("Magistral", size: 14))
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.white.opacity(0.1))
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(emailError == nil ? Color.gray.opacity(0.3) : errorRed, lineWidth: 1)
                                )
                                .onChange(of: email) { _ in 
                                    validateEmail()
                                }
                                .placeholder(when: email.isEmpty) {
                                    Text("Enter Your Email")
                                        .font(.custom("Magistral", size: 14))
                                        .foregroundColor(.gray)
                                        .padding(.leading, 16)
                                }
                        }
                        .padding(.bottom, 6)
                        
                        // Display email error if exists
                        if let error = emailError {
                            Text(error)
                                .font(.custom("Magistral", size: 12))
                                .foregroundColor(errorRed)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.bottom, 10)
                        } else {
                            Spacer().frame(height: 10)
                        }
                        
                        // Password Field
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Password")
                                .font(.custom("Magistral", size: 14))
                                .foregroundColor(.white)
                            
                            ZStack(alignment: .trailing) {
                                if isPasswordVisible {
                                    TextField("", text: $password)
                                        .font(.custom("Magistral", size: 14))
                                        .foregroundColor(.white)
                                        .padding()
                                        .background(Color.white.opacity(0.1))
                                        .cornerRadius(8)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 8)
                                                .stroke(passwordError == nil ? Color.gray.opacity(0.3) : errorRed, lineWidth: 1)
                                        )
                                        .onChange(of: password) { _ in 
                                            validatePassword()
                                        }
                                        .placeholder(when: password.isEmpty) {
                                            Text("Enter Password")
                                                .font(.custom("Magistral", size: 14))
                                                .foregroundColor(.gray)
                                                .padding(.leading, 16)
                                        }
                                } else {
                                    SecureField("", text: $password)
                                        .font(.custom("Magistral", size: 14))
                                        .foregroundColor(.white)
                                        .padding()
                                        .background(Color.white.opacity(0.1))
                                        .cornerRadius(8)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 8)
                                                .stroke(passwordError == nil ? Color.gray.opacity(0.3) : errorRed, lineWidth: 1)
                                        )
                                        .onChange(of: password) { _ in 
                                            validatePassword()
                                        }
                                        .placeholder(when: password.isEmpty) {
                                            Text("Enter Password")
                                                .font(.custom("Magistral", size: 14))
                                                .foregroundColor(.gray)
                                                .padding(.leading, 16)
                                        }
                                }
                                
                                // Eye icon for password visibility
                                Button(action: {
                                    isPasswordVisible.toggle()
                                }) {
                                    Image(systemName: isPasswordVisible ? "eye.slash.fill" : "eye.fill")
                                        .foregroundColor(.gray)
                                        .padding(.trailing, 16)
                                }
                            }
                        }
                        .padding(.bottom, 6)
                        
                        // Display password error if exists
                        if let error = passwordError {
                            Text(error)
                                .font(.custom("Magistral", size: 12))
                                .foregroundColor(errorRed)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.bottom, 10)
                        }
                        
                        // Sign up and Forgot Password links with equal spacing
                        HStack {
                            Button(action: {
                                // Sign up action (placeholder for now)
                            }) {
                                Text("Sign up for an account")
                                    .font(.custom("Magistral", size: 14))
                                    .foregroundColor(.white)
                                    .underline()
                            }
                            
                            Spacer()
                            
                            Button(action: {
                                // Forgot password action (placeholder for now)
                            }) {
                                Text("Forget Password")
                                    .font(.custom("Magistral", size: 14))
                                    .foregroundColor(.white)
                                    .underline()
                            }
                        }
                        .padding(.vertical, 20) // Equal padding top and bottom
                        
                        // Authentication error alert
                        if showAuthError {
                            Text(authErrorMessage)
                                .font(.custom("Magistral", size: 14))
                                .foregroundColor(errorRed)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding(.bottom, 10)
                        }
                        
                        // Login Button with 51px height
                        Button(action: {
                            // Validate form before proceeding
                            if validateForm() {
                                login()
                            }
                        }) {
                            ZStack {
                                Text("Login")
                                    .font(.custom("Magistral", size: 16))
                                    .foregroundColor(.white)
                                    .opacity(isLoading ? 0 : 1)
                                
                                if isLoading {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 51) // Exact 51px height
                            .background(isFormValid ? brandBlue : brandBlue.opacity(0.5))
                            .cornerRadius(8)
                        }
                        .padding(.bottom, 25)
                        
                        // Or divider with white bold text
                        HStack {
                            VStack { Divider().background(Color.white) }
                            Text("or")
                                .font(.custom("Magistral", size: 14).bold())
                                .foregroundColor(.white)
                                .padding(.horizontal, 10)
                            VStack { Divider().background(Color.white) }
                        }
                        .padding(.bottom, 25)
                        
                        // Social login buttons with proper logos
                        VStack(spacing: 16) {
                            // Google
                            Button(action: {
                                // Google login action
                            }) {
                                HStack {
                                    Image("logos_google")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 20, height: 20)
                                    
                                    Text("Continue with Google")
                                        .font(.custom("Magistral", size: 14))
                                        .foregroundColor(.white)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.white, lineWidth: 1)
                                )
                            }
                            
                            // Instagram
                            Button(action: {
                                // Instagram login action
                            }) {
                                HStack {
                                    Image("logos_instagram")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 20, height: 20)
                                    
                                    Text("Continue with Instagram")
                                        .font(.custom("Magistral", size: 14))
                                        .foregroundColor(.white)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.white, lineWidth: 1)
                                )
                            }
                            
                            // LinkedIn
                            Button(action: {
                                // LinkedIn login action
                            }) {
                                HStack {
                                    Image("logos_linkedin-icon")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 20, height: 20)
                                    
                                    Text("Continue with LinkedIn")
                                        .font(.custom("Magistral", size: 14))
                                        .foregroundColor(.white)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.white, lineWidth: 1)
                                )
                            }
                        }
                        .padding(.bottom, 40)
                    }
                    .padding(.horizontal, 32)
                }
            }
            .navigationBarHidden(true)
            .onAppear {
                // Print font info for debugging
                for family in UIFont.familyNames.sorted() {
                    let names = UIFont.fontNames(forFamilyName: family)
                    print("Family: \(family) font names: \(names)")
                }
            }
        }
    }
    
    // MARK: - Validation Methods
    
    private func validateEmail() {
        if email.isEmpty {
            emailError = nil
        } else if !isEmailValid {
            emailError = "Please enter a valid email address"
        } else {
            emailError = nil
        }
    }
    
    private func validatePassword() {
        if password.isEmpty {
            passwordError = nil
        } else if !isPasswordValid {
            passwordError = "Password must be at least 6 characters"
        } else {
            passwordError = nil
        }
    }
    
    private func validateForm() -> Bool {
        // Force validation of both fields
        validateEmail()
        validatePassword()
        
        // Check if email and password are not empty
        if email.isEmpty {
            emailError = "Email is required"
        }
        
        if password.isEmpty {
            passwordError = "Password is required"
        }
        
        return isFormValid && !email.isEmpty && !password.isEmpty
    }
    
    // MARK: - Authentication Methods
    
    private func login() {
        // Reset any previous auth errors
        showAuthError = false
        authErrorMessage = ""
        
        // Show loading state
        isLoading = true
        
        // Simulate network delay - in a real app, this would be an API call
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            // This is where you would implement actual authentication logic
            // For now, we'll simulate a successful login for the demo
            // In a real implementation, you would handle success and failure cases
            
            if email.lowercased() == "error@example.com" {
                // Simulate an authentication error
                showAuthError = true
                authErrorMessage = "Invalid email or password. Please try again."
                isLoading = false
            } else {
                // Success case - proceed to main interface
                isLoading = false
                AppCoordinator.shared.switchToMainInterface()
            }
        }
    }
}

// Placeholder extension to help with empty text fields
extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {
        
        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}

struct LoginScreenView_Previews: PreviewProvider {
    static var previews: some View {
        LoginScreenView()
    }
}
