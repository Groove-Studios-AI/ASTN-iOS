import SwiftUI

struct WorkoutPathView: View {
    let onWealthSelected: () -> Void
    let onBrandSelected: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Title and subtitle
            Text("Today's Wealth Workout")
                .font(.custom("Magistral", size: 20).bold())
                .foregroundColor(.white)
            
            Text("Choose Your Path")
                .font(.custom("Magistral", size: 16))
                .foregroundColor(.white.opacity(0.7))
            
            // Wealth and Brand options
            HStack(spacing: 16) {
                WorkoutOptionButton(
                    title: "Wealth",
                    iconName: "chart.bar.fill",
                    action: onWealthSelected
                )
                
                WorkoutOptionButton(
                    title: "Brand",
                    iconName: "gift.fill",
                    action: onBrandSelected
                )
            }
        }
        .padding(20)
        .background(Color.fromHex("#1E2787"))
        .cornerRadius(16)
    }
}

struct WorkoutOptionButton: View {
    let title: String
    let iconName: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                // Icon
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.2))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: iconName)
                        .foregroundColor(.white)
                        .font(.system(size: 24))
                }
                
                // Title
                Text(title)
                    .font(.custom("Magistral", size: 16).bold())
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(Color.fromHex("#0A4DA2").opacity(0.3))
            .cornerRadius(12)
        }
    }
}
