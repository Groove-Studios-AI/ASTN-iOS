import SwiftUI

struct WelcomeScreenView: View {
    // Define brand colors
    private let brandBlack = Color.fromHex("#0A0A0A")
    private let brandBlue = Color.fromHex("#1A2196")
    
    @State private var isActive = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Dark background for entire screen
                brandBlack
                    .ignoresSafeArea(.all)
                
                VStack(spacing: 0) {
                    // Image carousel section (top 60% of screen)
                    ZStack {
                        // Background image with grayscale filter
                        Image("splashImg")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(maxWidth: .infinity)
                            .frame(height: UIScreen.main.bounds.height * 0.6)
                            .grayscale(1.0) // Apply grayscale filter
                            .clipped()
                        
                        // Darker overlay gradient
                        LinearGradient(
                            gradient: Gradient(colors: [brandBlack.opacity(0.3), brandBlack.opacity(0.7)]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        .frame(height: UIScreen.main.bounds.height * 0.6)
                        
                        // Carousel content positioned at the bottom
                        VStack(spacing: 0) {
                            Spacer() // Push content to bottom
                            
                            // Main tagline with proper spacing
                            Text("Own Your Future")
                                .font(.custom("magistral", size: 28))
                                .foregroundColor(.white)
                                .padding(.bottom, 18) // Exactly 18px above pagination dots
                            
                            // Pagination dots 12px from bottom of image
                            HStack(spacing: 6) {
                                ForEach(0..<5) { index in
                                    Circle()
                                        .fill(index == 0 ? Color.white : Color.white.opacity(0.5))
                                        .frame(width: 6, height: 6)
                                }
                            }
                            .padding(.bottom, 12) // Exactly 12px from bottom edge
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    .frame(height: UIScreen.main.bounds.height * 0.6)
                    
                    // Text content below the image with equal spacing
                    VStack(spacing: 0) {
                        // ASTN logo - 18px below carousel
                        Text("ASTN")
                            .font(.custom("magistral", size: 34))
                            .foregroundColor(.white)
                            .padding(.top, 26) // Exactly 18px below the carousel
                            
                        Spacer()
                            .frame(height: 26) // 18px spacing between ASTN and next label
                        
                        // ASTN description
                        Text("Athlete Ownership Ecosystem")
                            .font(.custom("magistral", size: 22))
                            .foregroundColor(.white)
                            
                        Spacer()
                            .frame(height: 26) // 16px spacing between description and next label
                        
                        // Community description label
                        Text("Join the exclusive community of athletes building wealth.")
                            .font(.custom("magistral", size: 17))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .lineSpacing(4)
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: true)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.horizontal, 18)
                        
                        Spacer()
                            .frame(height: 26) // 16px spacing between community text and button
                        
                        // Get Started button - using brand blue
                        Button(action: {
                            // Add a small delay to ensure the button press is recognized
                            print("Get Started button pressed")
                            DispatchQueue.main.async {
                                // Navigate to the login screen using AppCoordinator
                                AppCoordinator.shared.switchToAuthFlow()
                            }
                        }) {
                            Text("Get Started")
                                .font(.custom("magistral", size: 17))
                                .foregroundColor(.white)
                                .frame(width: 160, height: 45)
                                .background(brandBlue)
                                .cornerRadius(22.5)
                        }
                        .padding(.bottom, 25)
                        
                        Spacer() // Push button up and maintain bottom padding
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .navigationBarHidden(true)
            .onAppear {
                // Make sure the font is correctly loaded
                for family in UIFont.familyNames.sorted() {
                    let names = UIFont.fontNames(forFamilyName: family)
                    print("Family: \(family) Font names: \(names)")
                }
            }
        }
    }
}

// Using the Color.init(hex:) extension from ViewExtensions.swift

struct WelcomeScreenView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeScreenView()
    }
}
