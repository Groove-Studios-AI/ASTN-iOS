import SwiftUI

struct ProfileTabView: View {
    // Add UserSession to access persisted user data
    @ObservedObject private var userSession = UserSession.shared
    @State private var showDebugInfo = false
    
    // State variables
    @State private var selectedInterests: Set<String> = ["Fitness", "Community"]
    @State private var currentTime = Date()
    @State private var showingSettings = false
    
    // Mock data for profile
    private let userData = ProfileData(
        name: "Jacob Cofie",
        category: "College Basketball",
        location: "Charlottesville, VA, United States",
        distance: 348,
        about: "Forward for the Virginia Cavaliers. Passionate about my family, the game of basketball, and the community.",
        interests: ["Fitness", "Community", "Education", "Music"]
    )
    
    // Time formatter for status bar
    private let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm"
        return formatter
    }()
    
    // Define brand colors
    private let brandBackground = Color.black
    
    var body: some View {
        ZStack {
            // Main content layer
            ZStack {
                // Background
                brandBackground.ignoresSafeArea()
                
                // Main Content
                ScrollView {
                    VStack(spacing: 0) {
                        // Profile Header with image
                        headerView
                            .edgesIgnoringSafeArea(.top)
                        
                        // Content sections
                        VStack(alignment: .leading, spacing: 0) {
                            // Category
                            Text(userData.category)
                                .font(.custom("Magistral", size: 15))
                                .foregroundColor(.white.opacity(0.9))
                                .padding(.bottom, 20)
                            
                            // Location Section
                            sectionHeader("Location")
                                .padding(.bottom, 10)
                            
                            locationRow
                                .padding(.bottom, 24)
                            
                            // About Section
                            sectionHeader("About")
                                .padding(.bottom, 10)
                            
                            aboutContent
                                .padding(.bottom, 24)
                            
                            // Interests Section
                            sectionHeader("Interests")
                                .padding(.bottom, 16)
                            
                            interestsGrid
                                .padding(.bottom, 28)
                            
                            // Gallery Section
                            gallerySection
                            
                            // Debug section - Divider
                            Divider()
                                .background(Color.white.opacity(0.2))
                                .padding(.vertical, 20)
                            
                            // Debug section toggle button
                            Button(action: {
                                showDebugInfo.toggle()
                            }) {
                                Text(showDebugInfo ? "Hide Onboarding Data" : "Show Onboarding Data")
                                    .font(.custom("Magistral", size: 14))
                                    .foregroundColor(.black)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 10)
                                    .background(Color.white.opacity(0.8))
                                    .cornerRadius(8)
                            }
                            .padding(.bottom, 15)
                            
                            // Debug info section
                            if showDebugInfo {
                                debugInfoContent(userSession: userSession)
                                    .padding(.bottom, 20)
                            }
                        }
                        .padding(.horizontal, 16)
                        
                        // Spacer for tab bar
                        Color.clear.frame(height: 80)
                    }
                }
            }
            .blur(radius: showingSettings ? 3 : 0) // Optional blur effect when settings are shown
            
            // Modal overlay layer
            if showingSettings {
                // Semi-transparent background overlay
                Color.black.opacity(0.3)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        showingSettings = false // Dismiss when tapping outside
                    }
                
                // Settings view
                SettingsView(isPresented: $showingSettings)
                    .transition(.scale)
            }
        }
        .animation(.easeInOut(duration: 0.2), value: showingSettings)
    }
    
    // MARK: - Header View
    private var headerView: some View {
        ZStack(alignment: .top) {
            // Profile Image - anchored to the top edge
            Image("testUserImage")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 300)
                .clipped()
                .overlay(
                    LinearGradient(
                        gradient: Gradient(colors: [.clear, .clear, .black.opacity(0.3), .black.opacity(0.8)]),
                        startPoint: .center,
                        endPoint: .bottom
                    )
                )
            
            VStack {
                // Top row - Settings Button
                HStack {
                    Spacer()
                    
                    Button(action: {
                        showingSettings = true
                    }) {
                        Text("Settings")
                            .font(.custom("Magistral", size: 15))
                            .foregroundColor(.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 6)
                            .background(Color.black.opacity(0.4))
                            .cornerRadius(16)
                    }
                }
                .padding(.top, 44) // Account for status bar height
                
                Spacer()
                
                // Bottom row - Edit Profile and Share buttons
                VStack(alignment: .leading, spacing: 12) {
                    // Name display
                    Text(userData.name)
                        .font(.custom("Magistral", size: 28))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    HStack {
                        // Edit Profile button
                        Button(action: {
                            // Action for edit profile
                        }) {
                            Text("Edit Profile")
                                .font(.custom("Magistral", size: 15))
                                .foregroundColor(.white)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 10)
                                .background(Color(red: 0.1, green: 0.1, blue: 0.1))
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                )
                        }
                        
                        Spacer()
                        
                        // Share button
                        Button(action: {
                            // Action for share
                        }) {
                            Image(systemName: "paperplane")
                                .font(.system(size: 16))
                                .foregroundColor(.white)
                                .padding(12)
                                .background(Color.black.opacity(0.6))
                                .clipShape(Circle())
                                .overlay(
                                    Circle()
                                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                )
                        }
                    }
                }
                .padding(.bottom, 20)
            }
            .padding(.horizontal, 20)
        }
    }
    
    // MARK: - Section Header
    private func sectionHeader(_ title: String) -> some View {
        Text(title)
            .font(.custom("Magistral", size: 24))
            .fontWeight(.medium)
            .foregroundColor(.white)
    }
    
    // MARK: - Location Row
    private var locationRow: some View {
        HStack(spacing: 10) {
            Text(userData.location)
                .font(.custom("Magistral", size: 16))
                .foregroundColor(.white.opacity(0.8))
                .lineLimit(1)
            
            Spacer()
            
            // Distance badge with location icon
            HStack(spacing: 6) {
                Image(systemName: "mappin.circle.fill")
                    .font(.system(size: 12))
                    .foregroundColor(.indigo)
                
                Text("\(userData.distance) mi")
                    .font(.custom("Magistral", size: 14))
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(Color.gray.opacity(0.2))
            .cornerRadius(16)
        }
    }
    
    // MARK: - About Content
    private var aboutContent: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(userData.about)
                .font(.custom("Magistral", size: 16))
                .foregroundColor(.white.opacity(0.75))
                .lineSpacing(3)
            
            Button(action: {
                // Read more action
            }) {
                Text("Read more")
                    .font(.custom("Magistral", size: 15))
                    .foregroundColor(.white.opacity(0.5))
            }
            .padding(.top, 2)
        }
    }
    
    // MARK: - Interests Grid
    private var interestsGrid: some View {
        let cellSpacing: CGFloat = 8 // Space between cells
        let itemsPerRow: CGFloat = 2
        
        return GeometryReader { proxy in
            let width = (proxy.size.width - cellSpacing * (itemsPerRow - 1)) / itemsPerRow
            
            VStack {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: width, maximum: width), spacing: cellSpacing)], spacing: cellSpacing) {
                    // Generate interest tags based on user data
                    ForEach(userData.interests, id: \.self) { interest in
                        InterestTag(title: interest, isSelected: selectedInterests.contains(interest))
                            .onTapGesture {
                                toggleInterest(interest)
                            }
                    }
                }
            }
        }
        .frame(height: userData.interests.count > 2 ? 150 : 100)
    }
    
    // MARK: - Gallery Section
    private var gallerySection: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Gallery header with See all button
            HStack {
                sectionHeader("Gallery")
                
                Spacer()
                
                Button(action: {
                    // See all action
                }) {
                    HStack(spacing: 4) {
                        Text("See all")
                            .font(.custom("Magistral", size: 15))
                            .foregroundColor(.white.opacity(0.6))
                        
                        Image(systemName: "chevron.right")
                            .font(.system(size: 12))
                            .foregroundColor(.white.opacity(0.6))
                    }
                }
            }
            .padding(.bottom, 12)
            
            // Gallery grid with just 5 images (2 on top row, 3 on bottom row)
            photoGrid
        }
    }
    
    // Photo grid for gallery
    private var photoGrid: some View {
        VStack(spacing: 8) {
            // First row - 2 photos
            HStack(spacing: 8) {
                galleryImage()
                galleryImage()
            }
            
            // Second row - 3 photos
            HStack(spacing: 8) {
                galleryImage()
                galleryImage()
                galleryImage()
            }
        }
    }
    
    // Gallery image helper
    private func galleryImage() -> some View {
        Image("testUserImage")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(height: 110)
            .frame(maxWidth: .infinity)
            .clipped()
            .cornerRadius(8)
    }
    
    // Gallery row with label
    private func galleryRow(_ label: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(label)
                    .font(.custom("Magistral", size: 16))
                    .foregroundColor(.white)
                
                Spacer()
                
                Text("See all")
                    .font(.custom("Magistral", size: 14))
                    .foregroundColor(.white.opacity(0.6))
            }
            
            HStack(spacing: 8) {
                galleryImage()
                galleryImage()
                galleryImage()
            }
        }
    }
    
    // Method to toggle interest selection
    private func toggleInterest(_ interest: String) {
        if selectedInterests.contains(interest) {
            selectedInterests.remove(interest)
        } else {
            selectedInterests.insert(interest)
        }
    }
}


    
    // MARK: - Debug Information View
    
    private func debugInfoContent(userSession: UserSession) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Onboarding Data")
                .font(.custom("Magistral-Bold", size: 18))
                .foregroundColor(.white)
            
            // Only show user data if available
            if let user = userSession.currentUser {
                Group {
                    // Display basic user info
                    infoRow(label: "User ID", value: user.id)
                    infoRow(label: "Email", value: user.email)
                    infoRow(label: "Account Type", value: user.isTemporary ? "Temporary" : "Permanent")
                    
                    // Step 1 Data
                    Divider().background(Color.white.opacity(0.3))
                    Text("Step 1 Data")
                        .font(.custom("Magistral-Bold", size: 16))
                        .foregroundColor(.white.opacity(0.9))
                        .padding(.top, 5)
                    
                    infoRow(label: "Athlete Type", value: user.athleteType?.rawValue ?? "Not Set")
                    infoRow(label: "Sport", value: user.sport ?? "Not Set")
                    infoRow(label: "Age", value: user.age != nil ? "\(user.age!)" : "Not Set")
                    
                    // Step 2 Data
                    Divider().background(Color.white.opacity(0.3))
                    Text("Step 2 Data")
                        .font(.custom("Magistral-Bold", size: 16))
                        .foregroundColor(.white.opacity(0.9))
                        .padding(.top, 5)
                    
                    // Show interests as a comma-separated list
                    let interestsList = user.interests?.map { $0.rawValue }.joined(separator: ", ") ?? "None"
                    infoRow(label: "Interests", value: interestsList)
                    
                    // Step 3 Data
                    Divider().background(Color.white.opacity(0.3))
                    Text("Step 3 Data")
                        .font(.custom("Magistral-Bold", size: 16))
                        .foregroundColor(.white.opacity(0.9))
                        .padding(.top, 5)
                    
                    infoRow(label: "Mindset Profile", value: user.mindsetProfile?.rawValue ?? "Not Set")
                    
                    // Onboarding Progress
                    Divider().background(Color.white.opacity(0.3))
                    Text("Onboarding Progress")
                        .font(.custom("Magistral-Bold", size: 16))
                        .foregroundColor(.white.opacity(0.9))
                        .padding(.top, 5)
                    
                    infoRow(label: "Current Step", value: "\(user.onboarding.currentStep)/\(user.onboarding.totalSteps)")
                    infoRow(label: "Steps Completed", value: "\(user.onboarding.stepsCompleted)")
                    infoRow(label: "Survey Completed", value: user.onboarding.surveyCompleted ? "Yes" : "No")
                }
            } else {
                Text("No user data available!")
                    .font(.custom("Magistral", size: 16))
                    .foregroundColor(.red)
            }
        }
        .padding(15)
        .background(Color.black.opacity(0.7))
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.white.opacity(0.3), lineWidth: 1)
        )
    }
    
    // Helper function to create info rows
    private func infoRow(label: String, value: String) -> some View {
        HStack(alignment: .top) {
            Text("\(label):")
                .font(.custom("Magistral", size: 14))
                .foregroundColor(.white.opacity(0.7))
                .frame(width: 120, alignment: .leading)
            
            Text(value)
                .font(.custom("Magistral", size: 14))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
// MARK: - Supporting Structures

// Profile data structure
struct ProfileData {
    let name: String
    let category: String
    let location: String
    let distance: Int
    let about: String
    let interests: [String]
}

// Interest Tag Component
struct InterestTag: View {
    let title: String
    let isSelected: Bool
    
    var body: some View {
        HStack(spacing: 6) {
            if isSelected {
                Image(systemName: "checkmark")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.white)
            }
            
            Text(title)
                .font(.custom("Magistral", size: 16))
                .foregroundColor(.white)
                .lineLimit(1)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .frame(height: 40)
        .background(isSelected ? Color(red: 0.3, green: 0.3, blue: 0.35) : Color.black.opacity(0.2))
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(isSelected ? Color.white.opacity(0.5) : Color.white.opacity(0.2), lineWidth: 1)
        )
    }
}

// Preview
struct ProfileTabView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileTabView()
    }
}
