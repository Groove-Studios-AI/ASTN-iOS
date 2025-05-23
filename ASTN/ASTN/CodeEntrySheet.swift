import SwiftUI
import Amplify

// The extensions (placeholder and Color.init(hex:)) are defined in ViewExtensions.swift

struct CodeEntrySheet: View {
    var email: String
    var onComplete: () -> Void
    var onDismiss: () -> Void
    
    @State private var code: String = ""
    @State private var codeError: String? = nil
    @State private var isLoading: Bool = false
    
    // ASTN's color scheme
    private let accentBlue = Color(hex: "3432EC")
    private let errorRed = Color(hex: "FF3B30")
    private let darkBackground = Color(hex: "191919")
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background color
                Color.black.edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 20) {
                    Text("Email Verification")
                        .font(.custom("Magistral", size: 24))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.top, 20)
                    
                    Text("Please enter the 6-digit code sent to \(email)")
                        .font(.custom("Magistral", size: 16))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    // Code entry field
                    TextField("", text: $code)
                        .font(.custom("Magistral", size: 18))
                        .foregroundColor(.white)
                        .keyboardType(.numberPad)
                        .padding()
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(codeError == nil ? Color.gray.opacity(0.3) : errorRed, lineWidth: 1)
                        )
                        .onChange(of: code) { _ in
                            // Clear error when user types
                            codeError = nil
                        }
                        .placeholder(when: code.isEmpty) {
                            Text("Enter verification code")
                                .font(.custom("Magistral", size: 16))
                                .foregroundColor(.gray)
                                .padding(.leading, 6)
                        }
                        .padding(.horizontal)
                    
                    // Error message
                    if let error = codeError {
                        Text(error)
                            .font(.custom("Magistral", size: 14))
                            .foregroundColor(errorRed)
                            .padding(.horizontal)
                    }
                    
                    // Verify button
                    Button(action: {
                        confirmCode()
                    }) {
                        ZStack {
                            Rectangle()
                                .fill(accentBlue)
                                .cornerRadius(8)
                                .frame(height: 50)
                            
                            if isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            } else {
                                Text("Verify")
                                    .font(.custom("Magistral", size: 16))
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                            }
                        }
                    }
                    .disabled(code.isEmpty || isLoading)
                    .padding(.horizontal)
                    
                    Text("Didn't receive a code? Check your spam folder.")
                        .font(.custom("Magistral", size: 14))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    Spacer()
                }
                .padding()
            }
            .navigationBarItems(trailing: Button(action: {
                onDismiss()
            }) {
                Image(systemName: "xmark")
                    .foregroundColor(.white)
                    .padding()
            })
        }
    }
    
    private func confirmCode() {
        guard !code.isEmpty else { return }
        
        // Show loading indicator
        isLoading = true
        
        Task {
            do {
                // Call Amplify to confirm the signup
                let result = try await Amplify.Auth.confirmSignUp(for: email, confirmationCode: code)
                
                // Handle the result on the main thread
                await MainActor.run {
                    isLoading = false
                    
                    if result.isSignUpComplete {
                        // ✅ Verification successful
                        onComplete()
                    } else {
                        // Cognito says we still need another step
                        codeError = "Verification not complete – try again."
                    }
                }
            } catch let authError as AuthError {
                // Handle Amplify-specific auth errors
                await MainActor.run {
                    isLoading = false
                    codeError = authError.errorDescription
                }
            } catch {
                // Handle any other errors
                await MainActor.run {
                    isLoading = false
                    codeError = "Error: \(error.localizedDescription)"
                }
            }
        }
    }
}


