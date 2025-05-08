import SwiftUI

struct DailyStreakView: View {
    let currentStreak: Int
    let maxStreak: Int
    let onCompleteWorkout: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                // Circular progress indicator
                CircularProgressView(
                    progress: Double(currentStreak) / Double(maxStreak),
                    strokeWidth: 8,
                    fontSize: 20,
                    maxValue: maxStreak
                )
                .frame(width: 70, height: 70)
                
                // Streak info
                VStack(alignment: .leading) {
                    Text("Current Streak")
                        .font(.custom("Magistral", size: 14))
                        .foregroundColor(.gray)
                    
                    Text("Day \(currentStreak) of \(maxStreak)")
                        .font(.custom("Magistral", size: 18).bold())
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                // Calendar button
                Button(action: {}) {
                    Image(systemName: "calendar")
                        .foregroundColor(.white)
                        .font(.system(size: 20))
                        .padding(8)
                }
            }
            
            // Workout button
            Button(action: onCompleteWorkout) {
                Text("Complete Workout to Keep Streak Alive")
                    .font(.custom("Magistral", size: 16).bold())
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Color.fromHex("#1E2787"))
                    .cornerRadius(8)
            }
        }
        .padding(20)
        .background(Color.fromHex("#121212"))
        .cornerRadius(16)
    }
}
