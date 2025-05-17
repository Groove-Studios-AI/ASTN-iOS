import SwiftUI

struct VideosListView: View {
    let videos: [Video]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            Text("Featured Videos")
                .font(.custom("Magistral", size: 20).bold())
                .foregroundColor(.white)
                .padding(.horizontal)
            
            // Horizontal scrollable content
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(videos) { video in
                        VideoCardView(video: video)
                            .frame(width: 170) // 63% of the original width (270px)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}
