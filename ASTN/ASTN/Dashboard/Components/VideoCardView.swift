import SwiftUI

struct VideoCardView: View {
    let video: Video
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Video thumbnail
            ZStack(alignment: .center) {
                // Placeholder image or actual thumbnail
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .aspectRatio(1.6, contentMode: .fit)
                    .cornerRadius(8)
                
                // Play button overlay
                Circle()
                    .fill(Color.black.opacity(0.5))
                    .frame(width: 44, height: 44)
                
                Image(systemName: "play.fill")
                    .font(.system(size: 20))
                    .foregroundColor(.white)
                
                // Premium badge if applicable
                if video.isPremium {
                    VStack {
                        HStack {
                            Spacer()
                            
                            Text("PREMIUM")
                                .font(.custom("Magistral", size: 10).bold())
                                .foregroundColor(.black)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.yellow)
                                .cornerRadius(4)
                        }
                        
                        Spacer()
                    }
                    .padding(8)
                }
            }
            
            // Video title
            Text(video.title)
                .font(.custom("Magistral", size: 16).bold())
                .foregroundColor(.white)
                .lineLimit(2)
            
            // Video description
            Text(video.description)
                .font(.custom("Magistral", size: 12))
                .foregroundColor(.white.opacity(0.7))
                .lineLimit(2)
            
            // Duration
            HStack {
                Image(systemName: "clock")
                    .font(.system(size: 12))
                    .foregroundColor(.white.opacity(0.6))
                
                Text("\(video.durationMinutes) min")
                    .font(.custom("Magistral", size: 12))
                    .foregroundColor(.white.opacity(0.6))
                
                Spacer()
                
                // Watch button
                Text("Watch")
                    .font(.custom("Magistral", size: 12).bold())
                    .foregroundColor(Color.fromHex("#7A6BFF"))
            }
        }
        .padding(12)
        .background(Color.fromHex("#121212"))
        .cornerRadius(12)
    }
}
