import SwiftUI
import UIKit

struct LoginScreenView: View {
    // Define brand colors
    private let brandBlack = Color.fromHex("#0A0A0A")
    private let brandBlue = Color.fromHex("#1A2196")
    
    // State variables for form fields
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isPasswordVisible: Bool = false
    
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
                                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                )
                                .placeholder(when: email.isEmpty) {
                                    Text("Enter Your Email")
                                        .font(.custom("Magistral", size: 14))
                                        .foregroundColor(.gray)
                                        .padding(.leading, 16)
                                }
                        }
                        .padding(.bottom, 20)
                        
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
                                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                        )
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
                                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                        )
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
                        .padding(.bottom, 16)
                        
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
                        
                        // Login Button with 51px height
                        Button(action: {
                            // Use AppCoordinator to replace the entire view hierarchy
                            AppCoordinator.shared.switchToMainInterface()
                        }) {
                            Text("Login")
                                .font(.custom("Magistral", size: 16))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 51) // Exact 51px height
                                .background(brandBlue)
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
