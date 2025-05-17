import SwiftUI

struct OwnershipModal: View {
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
                    // Main content - vertically stacked with center alignment
                    VStack(spacing: 0) { // Remove default spacing for precise control
                        Spacer().frame(height: 30) // Reduced top spacing to position title lower
                        
                        // Title - positioned closer to center
                        Text("Coming Soon")
                            .font(.custom("Magistral", size: 24))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding(.bottom, 10) // More space between title and subtitle
                        
                        // Subtitle - positioned closer to vertical center
                        Text("These features unlock as more athletes join.")
                            .font(.custom("Magistral", size: 16))
                            .foregroundColor(.white.opacity(0.7))
                            .multilineTextAlignment(.center)
                            .lineLimit(1) // Single line as in screenshot
                            .padding(.horizontal, 20)
                            .padding(.bottom, 30) // Increased bottom spacing
                        
                        Spacer() // Flexible space to center the remaining elements
                        
                        // Call to action text - vertically centered in the modal
                        Text("Want to help unlock faster?")
                            .font(.custom("Magistral", size: 16))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding(.bottom, 14) // Spacing before button
                        
                        // Share button - match styling from screenshot
                        Button(action: {
                            shareApp()
                        }) {
                            HStack(spacing: 10) {
                                Image(systemName: "square.and.arrow.up")
                                    .font(.system(size: 16))
                                Text("Share ASTN to your team")
                                    .font(.custom("Magistral", size: 16))
                            }
                            .foregroundColor(.white)
                            .frame(width: 280) // Fixed width
                            .frame(height: 44) // Fixed height
                            .background(Color.fromHex("#2936CA")) // Match blue from screenshot
                            .cornerRadius(8)
                        }
                        .padding(.bottom, 24) // Proper bottom padding
                    }
                    
                    // Close button positioned in upper right of modal
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            isPresented = false
                        }
                    }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white)
                    }
                    .frame(width: 40, height: 40) // Fixed size tap target
                    .padding(.top, 10) // Position from top edge
                    .padding(.trailing, 10) // Position from right edge
                }
                .frame(maxWidth: .infinity)
                .frame(height: 210) // Increased to 210px height as requested
                .background(Color.black)
                .overlay(
                    RoundedRectangle(cornerRadius: 0)
                        .stroke(Color.white.opacity(0.2), lineWidth: 1) // 1px border as requested
                )
                
                Spacer() // Push up from bottom
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
        .transition(.opacity)
        .animation(.easeInOut(duration: 0.25), value: isPresented)
    }
    
    // Function to share the app
    private func shareApp() {
        let appURL = URL(string: "https://astn.app")!
        let shareText = "Join me on ASTN - the app for athletes to build wealth and ownership!"
        
        let activityViewController = UIActivityViewController(
            activityItems: [shareText, appURL],
            applicationActivities: nil
        )
        
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootViewController = scene.windows.first?.rootViewController {
            // Find the presented view controller
            var presentedVC = rootViewController
            while let presented = presentedVC.presentedViewController {
                presentedVC = presented
            }
            
            // Present the share sheet
            presentedVC.present(activityViewController, animated: true)
        }
    }
}

// Preview
struct OwnershipModal_Previews: PreviewProvider {
    static var previews: some View {
        OwnershipModal(isPresented: .constant(true))
    }
}
