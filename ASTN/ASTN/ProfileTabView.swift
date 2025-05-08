import SwiftUI

struct ProfileTabView: View {
    // State variables
    @State private var selectedInterests: Set<String> = ["Fitness", "Community"]
    
    // Mock data for profile
    private let userData = ProfileData(
        name: "Jacob Cofie",
        category: "College Basketball",
        location: "Charlottesville, VA, United States",
        distance: 348,
        about: "Forward for the Virginia Cavaliers. Passionate about my family, the game of basketball, and the community.",
        interests: ["Fitness", "Community", "Education", "Music"]
    )
    
    // Define brand colors
    private let brandBlack = Color.black
    private let brandBackground = Color.black
    
    var body: some View {
        ZStack {
            // Background color
            brandBackground.ignoresSafeArea()
            
            // Main Content
            ScrollView {
                VStack(spacing: 0) {
                    // Profile Image and Settings
                    ProfileHeaderView()
                        .padding(.bottom, 16)
                    
                    // Category
                    Text(userData.category)
                        .font(.custom("Magistral", size: 16))
                        .foregroundColor(.white)
                        .padding(.bottom, 24)
                    
                    // Location Section
                    ProfileSectionView(title: "Location") {
                        HStack {
                            Text(userData.location)
                                .font(.custom("Magistral", size: 16))
                                .foregroundColor(.white.opacity(0.8))
                            
                            Spacer()
                            
                            // Distance badge
                            HStack(spacing: 4) {
                                Image(systemName: "location.fill")
                                    .font(.system(size: 14))
                                    .foregroundColor(.white)
                                
                                Text("\(userData.distance) mi")
                                    .font(.custom("Magistral", size: 14))
                                    .foregroundColor(.white)
                            }
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.gray.opacity(0.3))
                            .cornerRadius(12)
                        }
                    }
                    .padding(.bottom, 24)
                    
                    // About Section
                    ProfileSectionView(title: "About") {
                        VStack(alignment: .leading, spacing: 12) {
                            Text(userData.about)
                                .font(.custom("Magistral", size: 16))
                                .foregroundColor(.white.opacity(0.8))
                                .lineSpacing(4)
                            
                            Button(action: {
                                // Action for read more
                            }) {
                                Text("Read more")
                                    .font(.custom("Magistral", size: 16))
                                    .foregroundColor(.white.opacity(0.6))
                            }
                        }
                    }
                    .padding(.bottom, 24)
                    
                    // Interests Section
                    ProfileSectionView(title: "Interests") {
                        VStack(alignment: .leading, spacing: 12) {
                            // First row of interests
                            HStack(spacing: 12) {
                                InterestTagView(title: "Fitness", isSelected: selectedInterests.contains("Fitness"))
                                    .onTapGesture {
                                        toggleInterest("Fitness")
                                    }
                                
                                InterestTagView(title: "Community", isSelected: selectedInterests.contains("Community"))
                                    .onTapGesture {
                                        toggleInterest("Community")
                                    }
                            }
                            
                            // Second row of interests
                            HStack(spacing: 12) {
                                InterestTagView(title: "Education", isSelected: selectedInterests.contains("Education"))
                                    .onTapGesture {
                                        toggleInterest("Education")
                                    }
                                
                                InterestTagView(title: "Music", isSelected: selectedInterests.contains("Music"))
                                    .onTapGesture {
                                        toggleInterest("Music")
                                    }
                            }
                            
                            // Additional interest
                            HStack(spacing: 12) {
                                InterestTagView(title: "Fitness", isSelected: selectedInterests.contains("Fitness"))
                                    .onTapGesture {
                                        toggleInterest("Fitness")
                                    }
                            }
                        }
                    }
                    .padding(.bottom, 24)
                    
                    // Gallery Section
                    ProfileSectionView(title: "Gallery", trailingItem: {
                        Button(action: {
                            // Action for see all
                        }) {
                            HStack(spacing: 4) {
                                Text("See all")
                                    .font(.custom("Magistral", size: 16))
                                    .foregroundColor(.white.opacity(0.6))
                                
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 12))
                                    .foregroundColor(.white.opacity(0.6))
                            }
                        }
                    }) {
                        GalleryGridView()
                    }
                    
                    // Additional space for tab bar
                    Color.clear.frame(height: 80)
                }
                .padding(.top, 16)
                .padding(.horizontal, 16)
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

// Profile data structure
struct ProfileData {
    let name: String
    let category: String
    let location: String
    let distance: Int
    let about: String
    let interests: [String]
}

// Profile Header View with image and settings button
struct ProfileHeaderView: View {
    var body: some View {
        ZStack(alignment: .topTrailing) {
            // Profile Image
            Image("testUserImage")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 300)
                .clipped()
                .overlay(
                    LinearGradient(
                        gradient: Gradient(colors: [.clear, .black.opacity(0.7)]),
                        startPoint: .center,
                        endPoint: .bottom
                    )
                )
            
            // Settings Button
            Button(action: {
                // Action for settings
            }) {
                Text("Settings")
                    .font(.custom("Magistral", size: 16))
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color.black.opacity(0.5))
                    .cornerRadius(20)
            }
            .padding(.top, 16)
            .padding(.trailing, 16)
        }
    }
}

// Profile Section View
struct ProfileSectionView<Content: View, TrailingItem: View>: View {
    let title: String
    let trailingItem: () -> TrailingItem
    let content: () -> Content
    
    init(title: String, @ViewBuilder content: @escaping () -> Content) where TrailingItem == EmptyView {
        self.title = title
        self.content = content
        self.trailingItem = { EmptyView() }
    }
    
    init(title: String, @ViewBuilder trailingItem: @escaping () -> TrailingItem, @ViewBuilder content: @escaping () -> Content) {
        self.title = title
        self.trailingItem = trailingItem
        self.content = content
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(title)
                    .font(.custom("Magistral", size: 24))
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                
                Spacer()
                
                trailingItem()
            }
            
            content()
        }
    }
}

// Interest Tag View
struct InterestTagView: View {
    let title: String
    let isSelected: Bool
    
    var body: some View {
        HStack(spacing: 8) {
            if isSelected {
                Image(systemName: "checkmark")
                    .font(.system(size: 14))
                    .foregroundColor(.white)
            }
            
            Text(title)
                .font(.custom("Magistral", size: 16))
                .foregroundColor(.white)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(Color.black.opacity(0.3))
        .overlay(
            RoundedRectangle(cornerRadius: 30)
                .stroke(isSelected ? Color.white : Color.white.opacity(0.5), lineWidth: 1)
        )
        .cornerRadius(30)
    }
}

// Gallery Grid View
struct GalleryGridView: View {
    var body: some View {
        VStack(spacing: 16) {
            // First row of gallery images
            HStack(spacing: 8) {
                // Using the testUserImage in the gallery grid
                Image("testUserImage")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 120)
                    .frame(maxWidth: .infinity)
                    .clipped()
                    .cornerRadius(8)
                
                Image("testUserImage")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 120)
                    .frame(maxWidth: .infinity)
                    .clipped()
                    .cornerRadius(8)
            }
            
            // Second row of gallery images
            HStack(spacing: 8) {
                Image("testUserImage")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 120)
                    .frame(maxWidth: .infinity)
                    .clipped()
                    .cornerRadius(8)
                
                Image("testUserImage")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 120)
                    .frame(maxWidth: .infinity)
                    .clipped()
                    .cornerRadius(8)
                
                Image("testUserImage")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 120)
                    .frame(maxWidth: .infinity)
                    .clipped()
                    .cornerRadius(8)
            }
            
            // Additional rows of gallery with duplicated structure to match design
            GalleryRowWithLabel(label: "Gallery")
            GalleryRowWithLabel(label: "Gallery")
        }
    }
}

// Gallery row with label - for the duplicated sections in the design
struct GalleryRowWithLabel: View {
    let label: String
    
    var body: some View {
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
                Image("testUserImage")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 100)
                    .frame(maxWidth: .infinity)
                    .clipped()
                    .cornerRadius(8)
                
                Image("testUserImage")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 100)
                    .frame(maxWidth: .infinity)
                    .clipped()
                    .cornerRadius(8)
                
                Image("testUserImage")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 100)
                    .frame(maxWidth: .infinity)
                    .clipped()
                    .cornerRadius(8)
            }
        }
    }
}

// Preview
struct ProfileTabView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileTabView()
    }
}
