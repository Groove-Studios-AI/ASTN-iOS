import SwiftUI

struct GamePreviewStatsView: View {
    // Callback when the user continues to the next step
    var onContinue: () -> Void
    
    // Colors
    private let brandBlack = Color.fromHex("#0A0A0A")
    private let brandBlue = Color.fromHex("#1A2196")
    private let brandWhite = Color.fromHex("#F7F5F6")
    
    // Stats data
    private let stats = [
        (icon: "brain", color: "#FAD1E1", percent: "93%", text: "felt mentally sharper"),
        (icon: "book", color: "#D1F0FA", percent: "90%", text: "expanded their vocabulary"),
        (icon: "function", color: "#FAF0D1", percent: "89%", text: "improved mental math skills"),
        (icon: "pencil", color: "#D1DBFA", percent: "88%", text: "boosted writing skills")
    ]
    
    var body: some View {
        ZStack {
            // Background
            brandBlack.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                // Header with ASTN Logo
                HStack {
                    Spacer()
                    Image("ASTN_LaunchLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 40)
                    Spacer()
                }
                .padding(.top, 16)
                .padding(.bottom, 16)
                
                // Progress indicator
                ZStack(alignment: .leading) {
                    // Background track
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 3)
                    
                    // Blue progress indicator - 75% progress
                    Rectangle()
                        .fill(brandBlue)
                        .frame(width: UIScreen.main.bounds.width * 0.75, height: 3)
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 40)
                
                // Heading
                Text("People just like you achieved\ngreat results with ASTN!")
                    .font(.custom("Magistral", size: 24))
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .foregroundColor(brandWhite)
                    .padding(.horizontal, 24)
                    .padding(.bottom, 32)
                
                // Stats card
                VStack(spacing: 0) {
                    ForEach(stats.indices, id: \.self) { index in
                        HStack(spacing: 16) {
                            // Icon circle
                            Circle()
                                .fill(Color.fromHex(stats[index].color))
                                .frame(width: 40, height: 40)
                                .overlay(
                                    Image(systemName: stats[index].icon)
                                        .foregroundColor(.black)
                                )
                            
                            // Percentage
                            Text(stats[index].percent)
                                .font(.custom("Magistral", size: 28))
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                            
                            // Description
                            Text(stats[index].text)
                                .font(.custom("Magistral", size: 16))
                                .foregroundColor(.black.opacity(0.8))
                                .lineLimit(2)
                                .fixedSize(horizontal: false, vertical: true)
                            
                            Spacer()
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 16)
                        
                        // Add divider except after the last item
                        if index < stats.count - 1 {
                            Divider()
                                .background(Color.gray.opacity(0.3))
                                .padding(.horizontal, 16)
                        }
                    }
                }
                .background(Color.white)
                .cornerRadius(16)
                .padding(.horizontal, 24)
                .padding(.bottom, 32)
                
                Spacer()
                
                // Continue button
                Button(action: {
                    onContinue()
                }) {
                    Text("Continue")
                        .font(.custom("Magistral", size: 18))
                        .fontWeight(.medium)
                        .foregroundColor(brandWhite)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(brandBlue)
                        .cornerRadius(8)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 32)
            }
        }
    }
}

#Preview {
    GamePreviewStatsView(onContinue: {})
}
