import SwiftUI

struct ProfileTabView: View {
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
            
            // Settings Button
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
        HStack {
            Text(userData.location)
                .font(.custom("Magistral", size: 16))
                .foregroundColor(.white.opacity(0.8))
                .lineLimit(1)
            
            Spacer()
            
            // Distance badge
            HStack(spacing: 4) {
                Image(systemName: "arrow.up.forward")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.white)
                
                Text("\(userData.distance) mi")
                    .font(.custom("Magistral", size: 14))
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(Color.black.opacity(0.5))
            .cornerRadius(14)
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
        let horizontalPadding: CGFloat = 16 // Leading/trailing padding of parent view
        let cellSpacing: CGFloat = 2 // Space between cells (10px as specified)
        let availableWidth = UIScreen.main.bounds.width - (horizontalPadding * 2) - cellSpacing
        let cellWidth = availableWidth / 2
        
        return VStack(alignment: .leading, spacing: 16) {
            // First row - Fitness and Community
            HStack(spacing: cellSpacing) {
                InterestTag(title: "Fitness", isSelected: true)
                    .frame(width: cellWidth)
                InterestTag(title: "Community", isSelected: true)
                    .frame(width: cellWidth)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, horizontalPadding)
            
            // Second row - Education and Music
            HStack(spacing: cellSpacing) {
                InterestTag(title: "Education", isSelected: false)
                    .frame(width: cellWidth)
                InterestTag(title: "Music", isSelected: false)
                    .frame(width: cellWidth)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, horizontalPadding)
            
            // Third row - Fitness again (single tag)
            HStack(spacing: cellSpacing) {
                InterestTag(title: "Fitness", isSelected: true)
                    .frame(width: cellWidth)
                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, horizontalPadding)
        }
        .padding(.horizontal, 0) // Remove any external padding from the VStack itself
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
    
    
    // MARK: - Supporting Structures
    
    // Interest Tag Component
    struct InterestTag: View {
        let title: String
        let isSelected: Bool
        
        // Define the custom gold color for selected interests
        private let selectedColor = Color(red: 232/255, green: 213/255, blue: 181/255) // #E8D5B5
        
        var body: some View {
            HStack(spacing: 10) {
                if isSelected {
                    Image(systemName: "checkmark")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(selectedColor)
                }
                
                Text(title)
                    .font(.custom("Magistral", size: 17))
                    .foregroundColor(isSelected ? selectedColor : .white)
                    .lineLimit(1)
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 14)
            .frame(height: 48) // Taller height to match design
            .background(Color.black.opacity(0.2))
            .overlay(
                Capsule()
                    .stroke(isSelected ? selectedColor : Color.white.opacity(0.3), lineWidth: 1)
            )
            .clipShape(Capsule()) // Using Capsule for more oval shape
        }
    }
    
    // Profile data structure
    struct ProfileData {
        let name: String
        let category: String
        let location: String
        let distance: Int
        let about: String
        let interests: [String]
    }
    
    // Preview
    struct ProfileTabView_Previews: PreviewProvider {
        static var previews: some View {
            ProfileTabView()
        }
    }
