import SwiftUI

// MARK: - Workout Model
struct WorkoutItem: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let icon: String // SF Symbol name or image name
    let iconBackgroundColor: Color
    let gradeLevel: String? // Optional grade level (B+)
    let basePoints: Int
    let bonusPoints: Int
    let durationMinutes: Int
    let startButtonColor: Color // For custom start button colors
}

// MARK: - Workout Card Component
struct WorkoutCard: View {
    let workout: WorkoutItem
    let onRulesPressed: () -> Void
    let onStartPressed: () -> Void
    let index: Int // Add index for alternating border colors
    
    // Define branded colors
    private let brandBlue = Color.fromHex("#1A2196")
    private let brandGold = Color.fromHex("#E8D5B5")
    private let brandBlack = Color.fromHex("#0A0A0A")
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Title and icon
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(workout.title)
                        .font(.custom("Magistral", size: 22))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text(workout.description)
                        .font(.custom("Magistral", size: 14))
                        .fontWeight(.light)
                        .foregroundColor(.white.opacity(0.7))
                        .lineLimit(1)
                }
                
                Spacer()
                
                // Icon circle with grade if available
                ZStack {
                    Circle()
                        .fill(workout.iconBackgroundColor)
                        .frame(width: 70, height: 70)
                    
                    if workout.title == "Speed Streak" {
                        Image(systemName: workout.icon)
                            .font(.system(size: 30))
                            .foregroundColor(.white)
                    } else if let grade = workout.gradeLevel {
                        Text(grade)
                            .font(.custom("Magistral", size: 24))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                }
            }
            .padding(.bottom, 16)
            
            // Points and time info
            HStack(spacing: 16) {
                HStack(spacing: 4) {
                    Image(systemName: "trophy.fill")
                        .font(.system(size: 14))
                    Text("\(workout.basePoints) pts")
                        .font(.custom("Magistral", size: 14))
                }
                .foregroundColor(.white)
                
                HStack(spacing: 4) {
                    Image(systemName: "plus.circle")
                        .font(.system(size: 14))
                    Text("+\(workout.bonusPoints) bonus")
                        .font(.custom("Magistral", size: 14))
                }
                .foregroundColor(.white)
                
                HStack(spacing: 4) {
                    Image(systemName: "clock")
                        .font(.system(size: 14))
                    Text("\(workout.durationMinutes) minutes")
                        .font(.custom("Magistral", size: 14))
                }
                .foregroundColor(.white)
                
                Spacer()
            }
            .padding(.bottom, 16)
            
            // Action buttons
            HStack(spacing: 12) {
                Button(action: onRulesPressed) {
                    Text("Rules")
                        .font(.custom("Magistral", size: 16))
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(brandBlack)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(brandGold, lineWidth: 1)
                        )
                        .cornerRadius(8)
                }
                
                Button(action: onStartPressed) {
                    Text("Start")
                        .font(.custom("Magistral", size: 16))
                        .fontWeight(.medium)
                        .foregroundColor(workout.title == "Brand Builder" ? brandBlack : .white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(workout.title == "Speed Streak" ? brandBlue : brandGold)
                        .cornerRadius(8)
                }
            }
        }
        .padding(20)
        .background(Color.black.opacity(0.3))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(index % 2 == 0 ? brandBlue : brandGold, lineWidth: 1)
        )
        .cornerRadius(16)
    }
}

// MARK: - Workout Placeholder Screens
struct SpeedStreakView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                Text("Speed Streak Workout")
                    .font(.custom("Magistral", size: 24))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text("Workout content will go here")
                    .font(.custom("Magistral", size: 18))
                    .foregroundColor(.white.opacity(0.8))
                
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Back to Workouts")
                        .font(.custom("Magistral", size: 16))
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.fromHex("#1A2196"))
                        .cornerRadius(8)
                }
            }
        }
        .navigationBarTitle("Speed Streak", displayMode: .inline)
    }
}

struct BrandBuilderView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                Text("Brand Builder Workout")
                    .font(.custom("Magistral", size: 24))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text("Workout content will go here")
                    .font(.custom("Magistral", size: 18))
                    .foregroundColor(.white.opacity(0.8))
                
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Back to Workouts")
                        .font(.custom("Magistral", size: 16))
                        .foregroundColor(Color.fromHex("#0A0A0A"))
                        .padding()
                        .background(Color.fromHex("#E8D5B5"))
                        .cornerRadius(8)
                }
            }
        }
        .navigationBarTitle("Brand Builder", displayMode: .inline)
    }
}

// MARK: - Main WorkoutsTabView
struct WorkoutsTabView: View {
    // Sample data - would come from your data model in production
    @State private var showingRules = false
    @State private var selectedWorkout: WorkoutItem? = nil
    @State private var activeWorkout: String? = nil
    
    private let workouts = [
        WorkoutItem(
            title: "Speed Streak",
            description: "Financial literacy at top speed",
            icon: "rocket.fill",
            iconBackgroundColor: Color.blue.opacity(0.7),
            gradeLevel: nil,
            basePoints: 10,
            bonusPoints: 5,
            durationMinutes: 5,
            startButtonColor: Color.blue
        ),
        WorkoutItem(
            title: "Brand Builder",
            description: "Master your personal brand language",
            icon: "person.fill",
            iconBackgroundColor: Color.black.opacity(0.5),
            gradeLevel: "B+",
            basePoints: 10,
            bonusPoints: 5,
            durationMinutes: 5,
            startButtonColor: Color(red: 232/255, green: 213/255, blue: 181/255) // #E8D5B5
        )
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background
                Color.black.edgesIgnoringSafeArea(.all)
                
                // Navigation links (hidden)
                Group {
                    NavigationLink(
                        destination: SpeedStreakView(),
                        isActive: Binding(
                            get: { activeWorkout == "Speed Streak" },
                            set: { if !$0 { activeWorkout = nil } }
                        ),
                        label: { EmptyView() }
                    )
                    
                    NavigationLink(
                        destination: BrandBuilderView(),
                        isActive: Binding(
                            get: { activeWorkout == "Brand Builder" },
                            set: { if !$0 { activeWorkout = nil } }
                        ),
                        label: { EmptyView() }
                    )
                }
                
                // Main content
                VStack(alignment: .leading, spacing: 24) {
                    // Header text
                    Text("Choose your workout for today. Complete both for maximum points.")
                        .font(.custom("Magistral", size: 18))
                        .foregroundColor(.white.opacity(0.8))
                        .padding(.horizontal, 20)
                        .padding(.top, 16)
                    
                    // Scrollable list of workout cards
                    ScrollView {
                        LazyVStack(spacing: 20) {
                            ForEach(Array(workouts.enumerated()), id: \.element.id) { index, workout in
                                WorkoutCard(
                                    workout: workout,
                                    onRulesPressed: {
                                        // Display rules for this workout
                                        selectedWorkout = workout
                                        showingRules = true
                                    },
                                    onStartPressed: {
                                        // Navigate to the appropriate workout view
                                        activeWorkout = workout.title
                                    },
                                    index: index
                                )
                                .padding(.horizontal, 20)
                            }
                            
                            // Space for future workouts
                            // As more workouts are added, they'll appear here
                            
                            // Extra padding at bottom for scrolling
                            Spacer().frame(height: 40)
                        }
                    }
                }
            }
            .navigationTitle("Daily Reps")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Daily Reps")
                        .font(.custom("Magistral", size: 20))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
            }
            .alert(isPresented: $showingRules) {
                Alert(
                    title: Text(selectedWorkout?.title ?? "Workout Rules"),
                    message: Text("Rules for \(selectedWorkout?.title ?? "this workout") would be displayed here."),
                    dismissButton: .default(Text("Got it"))
                )
            }
        }
    }
}

// MARK: - Preview
struct WorkoutsTabView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutsTabView()
            .preferredColorScheme(.dark)
    }
}
