import SwiftUI

struct ArticleCardView: View {
    let article: Article
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Article image
            ZStack(alignment: .topLeading) {
                // Placeholder image or actual image
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .aspectRatio(1.6, contentMode: .fit)
                    .cornerRadius(8)
                
                // Editor's choice badge if applicable
                if article.isEditorsChoice {
                    Text("Editor's Choice")
                        .font(.custom("Magistral", size: 10).bold())
                        .foregroundColor(.black)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.yellow)
                        .cornerRadius(4)
                        .padding(8)
                }
            }
            
            // Article title
            Text(article.title)
                .font(.custom("Magistral", size: 16).bold())
                .foregroundColor(.white)
                .lineLimit(2)
            
            // Article preview
            Text(article.previewText)
                .font(.custom("Magistral", size: 12))
                .foregroundColor(.white.opacity(0.7))
                .lineLimit(2)
            
            // Read time
            HStack {
                Image(systemName: "clock")
                    .font(.system(size: 12))
                    .foregroundColor(.white.opacity(0.6))
                
                Text("\(article.readTimeMinutes) min read")
                    .font(.custom("Magistral", size: 12))
                    .foregroundColor(.white.opacity(0.6))
                
                Spacer()
                
                // Read more button
                Text("Read")
                    .font(.custom("Magistral", size: 12).bold())
                    .foregroundColor(Color.fromHex("#7A6BFF"))
            }
        }
        .padding(12)
        .background(Color.fromHex("#121212"))
        .cornerRadius(12)
    }
}
