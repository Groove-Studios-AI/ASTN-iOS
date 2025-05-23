import SwiftUI
import AWSCognitoAuthPlugin
import Combine
import Amplify

struct SignupScreenView: View {
    // Define brand colors
    private let brandBlack = Color.fromHex("#0A0A0A")
    private let brandBlue = Color.fromHex("#1A2196")
    private let errorRed = Color.red.opacity(0.8)
    
    // Navigation
    @Environment(\.presentationMode) var presentationMode
    
    // State variables for form fields
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var isPasswordVisible: Bool = false
    @State private var isConfirmPasswordVisible: Bool = false
    
    // Validation states
    @State private var firstNameError: String? = nil
    @State private var lastNameError: String? = nil
    @State private var emailError: String? = nil
    @State private var passwordError: String? = nil
    @State private var confirmPasswordError: String? = nil
    @State private var showAuthError: Bool = false
    @State private var authErrorMessage: String = ""
    @State private var isLoading: Bool = false
    @State private var showCodeEntrySheet: Bool = false
    @State private var emailForConfirmation: String = ""
    
    // Computed properties for validation
    private var isFirstNameValid: Bool {
        return firstName.count >= 2
    }
    
    private var isLastNameValid: Bool {
        return lastName.count >= 2
    }
    
    private var isEmailValid: Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    private var isPasswordValid: Bool {
        return password.count >= 8 &&
           password.rangeOfCharacter(from: .lowercaseLetters) != nil &&
           password.rangeOfCharacter(from: .uppercaseLetters) != nil &&
           password.rangeOfCharacter(from: .decimalDigits) != nil
    }
    
    private var isConfirmPasswordValid: Bool {
        return password == confirmPassword && !confirmPassword.isEmpty
    }
    
    private var isFormValid: Bool {
        return isFirstNameValid && isLastNameValid && isEmailValid && isPasswordValid && isConfirmPasswordValid
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background color
                brandBlack.ignoresSafeArea(.all)
                
                // Show Code Entry Sheet when needed
                .sheet(isPresented: $showCodeEntrySheet) {
                    CodeEntrySheet(
                        email: emailForConfirmation,
                        onComplete: {
                            // When verification is complete, dismiss the sheet and go to onboarding
                            showCodeEntrySheet = false
                            AppCoordinator.shared.switchToOnboardingFlow()
                        },
                        onDismiss: {
                            // Just dismiss the sheet if the user cancels
                            showCodeEntrySheet = false
                        }
                    )
                    .preferredColorScheme(.dark)
                }
                
                ScrollView {
                    VStack(spacing: 0) {
                        // Sign Up Header
                        Text("Sign Up")
                            .font(.custom("Magistral", size: 24))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.bottom, 30)
                            .padding(.top, 20)
                        
                        // First Name Field
                        VStack(alignment: .leading, spacing: 8) {
                            Text("First Name")
                                .font(.custom("Magistral", size: 14))
                                .foregroundColor(.white)
                            
                            TextField("", text: $firstName)
                                .font(.custom("Magistral", size: 14))
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.white.opacity(0.1))
                                .cornerRadius(8)
                                .autocorrectionDisabled(true)
                                .textInputAutocapitalization(.words)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(firstNameError == nil ? Color.gray.opacity(0.3) : errorRed, lineWidth: 1)
                                )
                                .placeholder(when: firstName.isEmpty) {
                                    Text("Enter Your First Name")
                                        .font(.custom("Magistral", size: 14))
                                        .foregroundColor(.gray)
                                        .padding(.leading, 16)
                                }
                                .onChange(of: firstName) { _ in
                                    validateFirstName()
                                }
                            
                        }
                        .padding(.bottom, 6)
                        
                        // Display first name error if exists
                        if let error = firstNameError {
                            Text(error)
                                .font(.custom("Magistral", size: 12))
                                .foregroundColor(errorRed)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.bottom, 10)
                        } else {
                            Spacer().frame(height: 10)
                        }
                        
                        
                        // Last Name Field
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Last Name")
                                .font(.custom("Magistral", size: 14))
                                .foregroundColor(.white)
                            
                            TextField("", text: $lastName)
                                .font(.custom("Magistral", size: 14))
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.white.opacity(0.1))
                                .cornerRadius(8)
                                .autocorrectionDisabled(true)
                                .textInputAutocapitalization(.words)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(lastNameError == nil ? Color.gray.opacity(0.3) : errorRed, lineWidth: 1)
                                )
                                .placeholder(when: lastName.isEmpty) {
                                    Text("Enter Your Last Name")
                                        .font(.custom("Magistral", size: 14))
                                        .foregroundColor(.gray)
                                        .padding(.leading, 16)
                                }
                                .onChange(of: lastName) { _ in
                                    validateLastName()
                                }
                            
                        }
                        .padding(.bottom, 6)
                        
                        // Display last name error if exists
                        if let error = lastNameError {
                            Text(error)
                                .font(.custom("Magistral", size: 12))
                                .foregroundColor(errorRed)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.bottom, 10)
                        } else {
                            Spacer().frame(height: 10)
                        }
                        
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
                                .keyboardType(.emailAddress)
                                .autocorrectionDisabled(true)
                                .textInputAutocapitalization(.never)
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
                                        .autocorrectionDisabled(true)
                                        .textInputAutocapitalization(.never)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 8)
                                                .stroke(passwordError == nil ? Color.gray.opacity(0.3) : errorRed, lineWidth: 1)
                                        )
                                        .onChange(of: password) { _ in 
                                            validatePassword()
                                            validateConfirmPassword()
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
                                        .autocorrectionDisabled(true)
                                        .textInputAutocapitalization(.never)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 8)
                                                .stroke(passwordError == nil ? Color.gray.opacity(0.3) : errorRed, lineWidth: 1)
                                        )
                                        .onChange(of: password) { _ in 
                                            validatePassword()
                                            validateConfirmPassword()
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
                        } else {
                            Spacer().frame(height: 10)
                        }
                        
                        // Confirm Password Field
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Confirm Password")
                                .font(.custom("Magistral", size: 14))
                                .foregroundColor(.white)
                            
                            ZStack(alignment: .trailing) {
                                if isConfirmPasswordVisible {
                                    TextField("", text: $confirmPassword)
                                        .font(.custom("Magistral", size: 14))
                                        .foregroundColor(.white)
                                        .padding()
                                        .background(Color.white.opacity(0.1))
                                        .cornerRadius(8)
                                        .autocorrectionDisabled(true)
                                        .textInputAutocapitalization(.never)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 8)
                                                .stroke(confirmPasswordError == nil ? Color.gray.opacity(0.3) : errorRed, lineWidth: 1)
                                        )
                                        .onChange(of: confirmPassword) { _ in 
                                            validateConfirmPassword()
                                        }
                                        .placeholder(when: confirmPassword.isEmpty) {
                                            Text("Re-enter Password")
                                                .font(.custom("Magistral", size: 14))
                                                .foregroundColor(.gray)
                                                .padding(.leading, 16)
                                        }
                                } else {
                                    SecureField("", text: $confirmPassword)
                                        .font(.custom("Magistral", size: 14))
                                        .foregroundColor(.white)
                                        .padding()
                                        .background(Color.white.opacity(0.1))
                                        .cornerRadius(8)
                                        .autocorrectionDisabled(true)
                                        .textInputAutocapitalization(.never)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 8)
                                                .stroke(confirmPasswordError == nil ? Color.gray.opacity(0.3) : errorRed, lineWidth: 1)
                                        )
                                        .onChange(of: confirmPassword) { _ in 
                                            validateConfirmPassword()
                                        }
                                        .placeholder(when: confirmPassword.isEmpty) {
                                            Text("Re-enter Password")
                                                .font(.custom("Magistral", size: 14))
                                                .foregroundColor(.gray)
                                                .padding(.leading, 16)
                                        }
                                }
                                
                                // Eye icon for confirm password visibility
                                Button(action: {
                                    isConfirmPasswordVisible.toggle()
                                }) {
                                    Image(systemName: isConfirmPasswordVisible ? "eye.slash.fill" : "eye.fill")
                                        .foregroundColor(.gray)
                                        .padding(.trailing, 16)
                                }
                            }
                        }
                        .padding(.bottom, 6)
                        
                        // Display confirm password error if exists
                        if let error = confirmPasswordError {
                            Text(error)
                                .font(.custom("Magistral", size: 12))
                                .foregroundColor(errorRed)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.bottom, 10)
                        } else {
                            Spacer().frame(height: 10)
                        }
                        
                        // Authentication error alert
                        if showAuthError {
                            Text(authErrorMessage)
                                .font(.custom("Magistral", size: 14))
                                .foregroundColor(errorRed)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding(.vertical, 10)
                        }
                        
                        // Sign Up Button
                        Button(action: {
                            // Validate form before proceeding
                            if validateForm() {
                                signUp()
                            }
                        }) {
                            ZStack {
                                Text("Sign up")
                                    .font(.custom("Magistral", size: 16))
                                    .foregroundColor(.white)
                                    .opacity(isLoading ? 0 : 1)
                                
                                if isLoading {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 51)
                            .background(isFormValid ? brandBlue : brandBlue.opacity(0.5))
                            .cornerRadius(8)
                        }
                        .padding(.top, 15)
                        .padding(.bottom, 20)
                        
                        // Already have an account
                        HStack {
                            Text("Already have an account?")
                                .font(.custom("Magistral", size: 14))
                                .foregroundColor(.white)
                            
                            Button(action: {
                                // Navigate back to login screen
                                presentationMode.wrappedValue.dismiss()
                            }) {
                                Text("Login Now")
                                    .font(.custom("Magistral", size: 14))
                                    .foregroundColor(.white)
                                    .underline()
                            }
                        }
                        .padding(.bottom, 25)
                        
                        // Or divider
                        HStack {
                            VStack { Divider().background(Color.white) }
                            Text("or")
                                .font(.custom("Magistral", size: 14).bold())
                                .foregroundColor(.white)
                                .padding(.horizontal, 10)
                            VStack { Divider().background(Color.white) }
                        }
                        .padding(.bottom, 25)
                        
                        // Social login buttons
                        VStack(spacing: 16) {
                            // Google
                            Button(action: {
                                // Google signup action
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
                                // Instagram signup action
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
                        }
                        .padding(.bottom, 40)
                    }
                    .padding(.horizontal, 32)
                }
            }
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white)
                            .imageScale(.large)
                    }
                }
            }
        }
    }
    
    // MARK: - Validation Methods
    
    private func validateFirstName() {
        if firstName.isEmpty {
            firstNameError = nil
            return
        }
        
        if firstName.count < 2 {
            firstNameError = "First name must be at least 2 characters"
        } else {
            firstNameError = nil
        }
    }
    
    private func validateLastName() {
        if lastName.isEmpty {
            lastNameError = nil
            return
        }
        
        if lastName.count < 2 {
            lastNameError = "Last name must be at least 2 characters"
        } else {
            lastNameError = nil
        }
    }
    
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
            passwordError = "Password must be at least 8 characters and include upper-case, lower-case, and a number"
        } else {
            passwordError = nil
        }
    }
    
    private func validateConfirmPassword() {
        if confirmPassword.isEmpty {
            confirmPasswordError = nil
        } else if password != confirmPassword {
            confirmPasswordError = "Passwords do not match"
        } else {
            confirmPasswordError = nil
        }
    }
    
    private func validateForm() -> Bool {
        // Force validation of all fields
        validateFirstName()
        validateLastName()
        validateEmail()
        validatePassword()
        validateConfirmPassword()
        
        // Check if fields are not empty
        if firstName.isEmpty {
            firstNameError = "First name is required"
        }
        
        if lastName.isEmpty {
            lastNameError = "Last name is required"
        }
        
        if email.isEmpty {
            emailError = "Email is required"
        }
        
        if password.isEmpty {
            passwordError = "Password is required"
        }
        
        if confirmPassword.isEmpty {
            confirmPasswordError = "Please confirm your password"
        }
        
        return isFormValid && !firstName.isEmpty && !lastName.isEmpty && !email.isEmpty && !password.isEmpty && !confirmPassword.isEmpty
    }
    
    // MARK: - Authentication Methods
    
    private func signUp() {
        // Reset any previous auth errors
        showAuthError = false
        authErrorMessage = ""
        
        // Show loading state
        isLoading = true
        
        // Get access to UserSession
        let userSession = UserSession.shared
        
        // Register the user with AWS Cognito via UserSession
        let fullName = "\(firstName) \(lastName)"
        userSession.registerUser(email: email, password: password, name: fullName) { result in
            DispatchQueue.main.async {
                self.isLoading = false
                
                switch result {
                case .success(let user):
                    // User successfully registered and stored in UserSession
                    print("✅ User registered: \(user.id)")
                    
                    // Success case - proceed to onboarding flow
                    AppCoordinator.shared.switchToOnboardingFlow()
                    
                case .failure(let error):
                    // Handle specific registration errors
                    self.showAuthError = true
                    
                    if let sessionError = error as? SessionError {
                        switch sessionError {
                        case .confirmationRequired:
                            // Store email for confirmation
                            self.emailForConfirmation = self.email
                            // Show the code entry sheet instead of error message
                            self.showCodeEntrySheet = true
                            self.showAuthError = false
                            
                        case .userAlreadyExists:
                            self.authErrorMessage = "This email is already registered. Please use a different email or login."
                            
                        default:
                            self.authErrorMessage = "Registration failed: \(error.localizedDescription)"
                        }
                    } else if let amplifyError = error as? AuthError {
                        switch amplifyError {
                        
                        // ➊ high-level category
                        case .service(_, _, let underlyingError):
                            if let cognito = underlyingError as? AWSCognitoAuthError {
                                // ➋ fine-grained Cognito reason
                                switch cognito {
                                case .userNotConfirmed:
                                    self.authErrorMessage = "Please check your email for a verification code to complete signup."
                                
                                case .usernameExists:
                                    self.authErrorMessage = "This email is already registered. Please use a different email or login."
                                
                                default:
                                    self.authErrorMessage = "Registration failed: \(cognito.errorDescription)"
                                }
                            } else {
                                self.authErrorMessage = "Registration failed: \(amplifyError.errorDescription)"
                            }
                        
                        default:
                            self.authErrorMessage = "Registration failed: \(amplifyError.errorDescription)"
                        }
                    } else {
                        self.authErrorMessage = "Registration failed: \(error.localizedDescription)"
                    }
                }
            }
        }
    }
}

// Add a preview provider for this view
struct SignupScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SignupScreenView()
    }
}
