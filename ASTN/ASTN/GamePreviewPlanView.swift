import SwiftUI

struct GamePreviewPlanView: View {
    // Callback when the user completes the game preview
    var onComplete: () -> Void
    
    // Colors
    private let brandBlack = Color.fromHex("#0A0A0A")
    private let brandBlue = Color.fromHex("#1A2196")
    private let brandWhite = Color.fromHex("#F7F5F6")
    
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
                
                // Progress indicator - 100% complete
                ZStack(alignment: .leading) {
                    // Background track
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 3)
                    
                    // Blue progress indicator - 100% progress
                    Rectangle()
                        .fill(brandBlue)
                        .frame(width: UIScreen.main.bounds.width, height: 3)
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 40)
                
                // Heading
                Text("Your plan to master\nvocabulary is ready")
                    .font(.custom("Magistral", size: 24))
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .foregroundColor(brandWhite)
                    .padding(.horizontal, 24)
                    .padding(.bottom, 32)
                
                // Progress chart
                ZStack {
                    // Chart background
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.white)
                        .frame(height: 180)
                    
                    // Chart elements
                    VStack {
                        // Progress curve
                        ZStack {
                            // Gradient background for curve
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color.fromHex("#FF6B6B").opacity(0.3),
                                    Color.fromHex("#FFC24B").opacity(0.3),
                                    Color.fromHex("#8AE67E").opacity(0.3)
                                ]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                            .mask(
                                // Curved shape that fills below the line
                                Path { path in
                                    let width = UIScreen.main.bounds.width - 48
                                    let height: CGFloat = 100
                                    
                                    path.move(to: CGPoint(x: 0, y: height))
                                    path.addLine(to: CGPoint(x: 0, y: height * 0.8))
                                    
                                    // Curve that starts low and ends high
                                    path.addCurve(
                                        to: CGPoint(x: width, y: height * 0.2),
                                        control1: CGPoint(x: width * 0.3, y: height * 0.8),
                                        control2: CGPoint(x: width * 0.7, y: height * 0.2)
                                    )
                                    
                                    path.addLine(to: CGPoint(x: width, y: height))
                                    path.closeSubpath()
                                }
                            )
                            .frame(height: 100)
                            
                            // The actual curve line
                            Path { path in
                                let width = UIScreen.main.bounds.width - 48
                                let height: CGFloat = 100
                                
                                path.move(to: CGPoint(x: 0, y: height * 0.8))
                                
                                // Curve that starts low and ends high
                                path.addCurve(
                                    to: CGPoint(x: width, y: height * 0.2),
                                    control1: CGPoint(x: width * 0.3, y: height * 0.8),
                                    control2: CGPoint(x: width * 0.7, y: height * 0.2)
                                )
                            }
                            .stroke(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color.fromHex("#FF6B6B"),
                                        Color.fromHex("#FFC24B"),
                                        Color.fromHex("#8AE67E")
                                    ]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                ),
                                lineWidth: 3
                            )
                            .frame(height: 100)
                            
                            // Today marker
                            Circle()
                                .fill(Color.fromHex("#FF6B6B"))
                                .frame(width: 16, height: 16)
                                .overlay(
                                    Circle()
                                        .stroke(Color.white, lineWidth: 2)
                                )
                                .offset(x: -((UIScreen.main.bounds.width - 48) / 2) + 30, y: 30)
                                .overlay(
                                    Text("Today")
                                        .font(.custom("Magistral", size: 12))
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .background(Color.fromHex("#FF6B6B"))
                                        .cornerRadius(12)
                                        .offset(x: -((UIScreen.main.bounds.width - 48) / 2) + 30, y: 10)
                                )
                            
                            // 4 weeks marker
                            Circle()
                                .fill(Color.fromHex("#1A2196"))
                                .frame(width: 16, height: 16)
                                .overlay(
                                    Circle()
                                        .stroke(Color.white, lineWidth: 2)
                                )
                                .offset(x: ((UIScreen.main.bounds.width - 48) / 2) - 30, y: -30)
                                .overlay(
                                    Text("After\n4 weeks")
                                        .font(.custom("Magistral", size: 12))
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .background(Color.fromHex("#1A2196"))
                                        .cornerRadius(12)
                                        .offset(x: ((UIScreen.main.bounds.width - 48) / 2) - 30, y: -70)
                                )
                        }
                        
                        // Week markers
                        HStack {
                            ForEach(1...4, id: \.self) { week in
                                VStack {
                                    Circle()
                                        .fill(Color.gray.opacity(0.3))
                                        .frame(width: 8, height: 8)
                                    
                                    Text("Week \(week)")
                                        .font(.custom("Magistral", size: 12))
                                        .foregroundColor(.black.opacity(0.7))
                                }
                                
                                if week < 4 {
                                    Spacer()
                                }
                            }
                        }
                        .padding(.horizontal, 30)
                    }
                    .padding(.horizontal, 24)
                }
                .frame(height: 180)
                .padding(.horizontal, 24)
                .padding(.bottom, 24)
                
                // Description text
                VStack(spacing: 16) {
                    Text("In just 4 weeks, you can boost your focus and memory by 30%!")
                        .font(.custom("Magistral", size: 18))
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .foregroundColor(brandWhite)
                    
                    Text("With ASTN's personalized daily workouts, you'll engage in fun games that challenge your mind and help you achieve your cognitive goals. Are you ready to unlock your brain's full potential?")
                        .font(.custom("Magistral", size: 16))
                        .multilineTextAlignment(.center)
                        .foregroundColor(brandWhite.opacity(0.7))
                        .lineLimit(3)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 32)
                
                Spacer()
                
                // Continue button
                Button(action: {
                    onComplete()
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
    GamePreviewPlanView(onComplete: {})
}
