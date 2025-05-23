import SwiftUI

struct WelcomeHeaderView: View {
    let username: String
    let greeting: String
    let points: Int
    let onPointsTapped: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            // User avatar circle
            ZStack {
                Circle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 40, height: 40)
                
                Image(systemName: "person.fill")
                    .foregroundColor(.white)
                    .font(.system(size: 16))
            }
            
            // Welcome message
            VStack(alignment: .leading, spacing: 2) {
                Text(greeting)
                    .font(.custom("Magistral", size: 16).bold())
                    .foregroundColor(.white)
            }
            
            Spacer()
            
            // Points counter - now tappable
            Button(action: onPointsTapped) {
                HStack(spacing: 6) {
                    Text("\(points)")
                        .font(.custom("Magistral", size: 18).bold())
                        .foregroundColor(.white)
                    
                    Image(systemName: "flame.fill")
                        .foregroundColor(.orange)
                        .font(.system(size: 18))
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    Capsule()
                        .fill(Color.orange.opacity(0.2))
                )
            }
        }
        .padding(.vertical, 8)
    }
}
