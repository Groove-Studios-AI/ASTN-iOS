import SwiftUI

struct PremiumUpsellView: View {
    let onReturnHome: () -> Void
    let onUnlockPremium: () -> Void
    
    // Environment to hide the navigation bar back button
    @Environment(\.presentationMode) var presentationMode
    
    // Brand colors
    private let brandBlue = Color.fromHex("#1A2196")
    private let brandGold = Color.fromHex("#E8D5B5")
    
    var body: some View {
        ZStack {
            // Black background
            Color.black.edgesIgnoringSafeArea(.all)
            
            // Main content area
            VStack(alignment: .leading, spacing: 0) {
                // Title section
                VStack(spacing: 8) {
                    Text("Ready for More?")
                        .font(.custom("Magistral", size: 36))
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                        .padding(.top, 40)
                        .frame(maxWidth: .infinity, alignment: .center) // Center title
                    
                    Text("Check back tomorrow for your next module.")
                        .font(.system(size: 16))
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, alignment: .center) // Center subtitle
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 50)
                
                // Lock icon with blurred background
                ZStack {
                    // Blurred background
                    Rectangle()
                        .fill(Color.gray.opacity(0.15))
                        .frame(width: 140, height: 140)
                        .blur(radius: 15)
                    
                    // Lock icon
                    Image("lock-open")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 80, height: 80)
                        .foregroundColor(brandGold)
                }
                .frame(maxWidth: .infinity)
                .padding(.bottom, 60)
                
                // Premium info section
                VStack(alignment: .leading, spacing: 8) {
                    // Up Your Game and Unlock Premium side by side
                    HStack(alignment: .center) {
                        // Up Your Game headline
                        Text("Up Your Game!")
                            .font(.custom("Magistral", size: 24))
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        // Unlock Premium link
                        Button(action: { onUnlockPremium() }) {
                            Text("Unlock Premium")
                                .font(.custom("Magistral", size: 16))
                                .foregroundColor(.white)
                                .underline()
                        }
                    }
                    .padding(.bottom, 16)
                    
                    // Premium description
                    Text("With Premium Membership, unlock more daily modules, higher value equity opportunities, less daily restrictions, peer metrics & analysis, and so much more!")
                        .font(.system(size: 15))
                        .foregroundColor(.white)
                        .lineSpacing(4)
                }
                .padding(.horizontal, 20)
                
                Spacer()
                
                // Bottom action buttons - side by side layout
                HStack(spacing: 8) { // Small spacing between buttons
                    // Return Home button
                    Button(action: { onReturnHome() }) {
                        Text("Return Home")
                            .font(.custom("Magistral", size: 16))
                            .fontWeight(.medium)
                            .foregroundColor(Color.black)
                            .frame(maxWidth: .infinity)
                            .frame(height: 52)
                            .background(brandGold)
                            .cornerRadius(26)
                    }
                    
                    // Unlock ASTN+ button
                    Button(action: { onUnlockPremium() }) {
                        Text("Unlock ASTN+")
                            .font(.custom("Magistral", size: 16))
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 52)
                            .background(
                                RoundedRectangle(cornerRadius: 26)
                                    .stroke(brandGold, lineWidth: 1)
                            )
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 90) // Add extra bottom padding to account for tab bar
            }
        }
        // Hide the navigation bar back button
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
}

struct PremiumUpsellView_Previews: PreviewProvider {
    static var previews: some View {
        PremiumUpsellView(onReturnHome: {}, onUnlockPremium: {})
    }
}
