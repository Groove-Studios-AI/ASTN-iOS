import SwiftUI

struct PointsSystemModal: View {
    @Binding var isPresented: Bool
    
    var body: some View {
        // Parent view with semi-transparent background
        GeometryReader { geometry in
            // Semi-transparent black overlay covering the entire screen
            Color.black.opacity(0.5)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        isPresented = false
                    }
                }
            
            // Vertically centered modal container
            VStack {
                Spacer() // Push down from top
                
                // Modal content with close button
                ZStack(alignment: .topTrailing) {
                    // Main content
                    VStack(spacing: 0) {
                        Spacer().frame(height: 30)
                        
                        // Title
                        Text("Points System")
                            .font(.custom("Magistral", size: 24))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding(.bottom, 15)
                        
                        // Description
                        Text("You earn points by completing workouts and engaging\nwith ASTN.")
                            .font(.custom("Magistral", size: 16))
                            .foregroundColor(.white.opacity(0.7))
                            .multilineTextAlignment(.center)
                            .lineLimit(2)
                            .padding(.horizontal, 20)
                            .padding(.bottom, 30)
                        
                        // How to Earn Points section
                        VStack(alignment: .leading, spacing: 15) {
                            Text("How to Earn Points:")
                                .font(.custom("Magistral", size: 18))
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .padding(.bottom, 5)
                            
                            // Points earning methods
                            PointsRowView(activity: "Daily Login", points: "3 pts")
                            PointsRowView(activity: "Workout Completion", points: "5 pts")
                            PointsRowView(activity: "Bonus (3 days in a row)", points: "+2 pts")
                        }
                        .padding(.horizontal, 30)
                        .padding(.bottom, 25)
                        
                        // Daily Max section
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Daily Max:")
                                .font(.custom("Magistral", size: 18))
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .padding(.bottom, 5)
                            
                            // Daily limits
                            PointsRowView(activity: "Free Account", points: "7 pts/day")
                            PointsRowView(activity: "Premium Account", points: "20 pts/day")
                        }
                        .padding(.horizontal, 30)
                        .padding(.bottom, 25)
                        
                        // Action button
                        Button(action: {
                            // Handle action (e.g., navigate to upgrade)
                            withAnimation(.easeInOut(duration: 0.2)) {
                                isPresented = false
                            }
                        }) {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.white)
                                .frame(height: 50)
                                .overlay(
                                    Text("Upgrade to Premium")
                                        .font(.custom("Magistral", size: 16))
                                        .fontWeight(.semibold)
                                        .foregroundColor(.black)
                                )
                        }
                        .padding(.horizontal, 30)
                        .padding(.bottom, 20)
                        
                        // Bottom description
                        Text("Unlock advanced performance metrics as\nmore athletes join the platform.")
                            .font(.custom("Magistral", size: 14))
                            .foregroundColor(.white.opacity(0.6))
                            .multilineTextAlignment(.center)
                            .lineLimit(2)
                            .padding(.horizontal, 20)
                            .padding(.bottom, 30)
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.fromHex("#1C1C1E"))
                    )
                    .padding(.horizontal, 30)
                    
                    // Close button
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            isPresented = false
                        }
                    }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white.opacity(0.8))
                            .frame(width: 24, height: 24)
                            .background(
                                Circle()
                                    .fill(Color.white.opacity(0.1))
                            )
                    }
                    .padding(.top, 15)
                    .padding(.trailing, 45)
                }
                
                Spacer() // Push up from bottom
            }
        }
    }
}

// Helper view for points rows
struct PointsRowView: View {
    let activity: String
    let points: String
    
    var body: some View {
        HStack {
            Text(activity)
                .font(.custom("Magistral", size: 16))
                .foregroundColor(.white)
            
            Spacer()
            
            Text(points)
                .font(.custom("Magistral", size: 16))
                .fontWeight(.medium)
                .foregroundColor(.white)
        }
    }
}

// Preview
struct PointsSystemModal_Previews: PreviewProvider {
    static var previews: some View {
        PointsSystemModal(isPresented: .constant(true))
            .preferredColorScheme(.dark)
    }
}
