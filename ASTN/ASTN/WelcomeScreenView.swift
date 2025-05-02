import SwiftUI

struct WelcomeScreenView: View {
    // Define brand colors
    private let brandBlack = Color(hex: "#0A0A0A")
    private let brandBlue = Color(hex: "#1A2196")
    
    @State private var isActive = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Black background for entire screen
                brandBlack
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 0) {
                    // Image carousel section (top 60% of screen)
                    ZStack(alignment: .bottomLeading) {
                        // Background image with darker black/white filter
                        Image("splashImg")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(maxWidth: .infinity)
                            .frame(height: UIScreen.main.bounds.height * 0.6)
                            .colorMultiply(Color.gray.opacity(0.6))
                            .brightness(-0.2)
                            .contrast(1.2)
                            .clipped()
                        
                        // Darker overlay gradient
                        LinearGradient(
                            gradient: Gradient(colors: [brandBlack.opacity(0.3), brandBlack.opacity(0.7)]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        .frame(height: UIScreen.main.bounds.height * 0.6)
                        
                        // Main tagline
                        VStack(alignment: .center) {
                            Text("Own Your Future")
                                .font(.system(size: 38, weight: .bold))
                                .foregroundColor(.white)
                                .padding(.bottom, 20)
                                .frame(maxWidth: .infinity)
                            
                            // Pagination dots - smaller and more subtle
                            HStack(spacing: 6) {
                                ForEach(0..<5) { index in
                                    Circle()
                                        .fill(index == 0 ? Color.white : Color.white.opacity(0.5))
                                        .frame(width: 6, height: 6)
                                }
                            }
                            .padding(.bottom, 20)
                        }
                        .padding(.bottom, 40)
                        .padding(.horizontal, 20)
                        .frame(maxWidth: .infinity)
                    }
                    
                    // Text content below the image
                    VStack(spacing: 8) {
                        Spacer()
                        .frame(height: 40)
                        
                        // ASTN logo and description
                        Text("ASTN")
                            .font(.system(size: 42, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text("Athlete Ownership Ecosystem")
                            .font(.system(size: 17, weight: .medium))
                            .foregroundColor(.white)
                            .padding(.bottom, 16)
                        
                        Text("Join the exclusive community of athletes building wealth.")
                            .font(.system(size: 15))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .lineSpacing(4)
                            .padding(.horizontal, 40)
                        
                        Spacer()
                        
                        // Get Started button - using brand blue
                        Button(action: {
                            // Navigate to the next screen (login/signup)
                            self.isActive = true
                        }) {
                            Text("Get Started")
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(width: 160, height: 45)
                                .background(brandBlue)
                                .cornerRadius(22.5) // Fully rounded corners
                        }
                        .padding(.bottom, 40)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .navigationBarHidden(true)
            .navigationDestination(isPresented: $isActive) {
                Text("Login Screen") // Replace with your actual login/signup view
            }
        }
    }
}

// Extension to create Color from hex string
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

struct WelcomeScreenView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeScreenView()
    }
}
