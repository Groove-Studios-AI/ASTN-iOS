import SwiftUI

struct ArticlesListView: View {
    let articles: [Article]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            Text("Latest Articles")
                .font(.custom("Magistral", size: 20).bold())
                .foregroundColor(.white)
                .padding(.horizontal)
            
            // Horizontal scrollable content
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(articles) { article in
                        ArticleCardView(article: article)
                            .frame(width: 170) // 63% of the original width (270px)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}
