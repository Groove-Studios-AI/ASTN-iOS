import SwiftUI

// Main performance view container
struct PerformanceTabView: View {
    // State variables for tab selection and demo mode
    @State private var selectedSegment = 0
    @State private var isDemo = true // Set to true to show overlay
    
    // Define brand colors
    private let brandBlack = Color.fromHex("#0A0A0A")
    private let brandBackground = Color.fromHex("#1E2130")
    private let cardBackground = Color.fromHex("#161A24")
    
    var body: some View {
        ZStack {
            // Background color
            brandBackground.ignoresSafeArea()
            
            // Main Content
            VStack(spacing: 0) {
                // Header
                PerformanceHeaderView()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Today's Rep Card
                        TodaysRepCardView(cardBackground: cardBackground)
                        
                        // Performance Segments
                        PerformanceSegmentsView(selectedSegment: $selectedSegment, cardBackground: cardBackground)
                        
                        // Performance Ranking
                        PerformanceRankingView()
                    }
                    .padding(.bottom, 80) // Extra space for tab bar
                }
            }
            
            // Overlay for demo mode
            if isDemo {
                DemoOverlayView()
            }
        }
    }

}

// MARK: - Supporting Components

// Insight row component
struct InsightRow: View {
    var text: String
    
    var body: some View {
        HStack(spacing: 12) {
            // Checkmark circle
            ZStack {
                Circle()
                    .fill(Color.green.opacity(0.2))
                    .frame(width: 24, height: 24)
                
                Image(systemName: "checkmark")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.green)
            }
            
            Text(text)
                .font(.custom("Magistral", size: 14))
                .foregroundColor(.white.opacity(0.9))
        }
    }
}

// Header component
struct PerformanceHeaderView: View {
    var body: some View {
        HStack {
            Button(action: {
                // Back button action
            }) {
                Image(systemName: "arrow.left")
                    .foregroundColor(.white)
                    .font(.system(size: 18, weight: .medium))
            }
            
            Spacer()
            
            Text("Performance")
                .font(.custom("Magistral", size: 22))
                .foregroundColor(.white)
            
            Spacer()
            
            // Empty view to balance the back button
            Rectangle()
                .fill(Color.clear)
                .frame(width: 24, height: 24)
        }
        .padding(.horizontal, 20)
        .padding(.top, 15)
        .padding(.bottom, 20)
    }
}

// Today's Rep Card component
struct TodaysRepCardView: View {
    var cardBackground: Color
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(cardBackground)
                .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
            
            HStack(spacing: 16) {
                // Circle Progress
                ProgressCircleView(value: 0.85, color: .green, size: 90, content: {
                    VStack(spacing: 2) {
                        Text("85")
                            .font(.custom("Magistral", size: 32))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Text("points")
                            .font(.custom("Magistral", size: 14))
                            .foregroundColor(.white.opacity(0.7))
                    }
                })
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Today's Rep")
                        .font(.custom("Magistral", size: 20))
                        .foregroundColor(.white)
                    
                    Text("\"Your pace reflects\nyour financial clarity!\"")
                        .font(.custom("Magistral", size: 16))
                        .foregroundColor(.white.opacity(0.8))
                        .lineSpacing(4)
                    
                    HStack {
                        Image(systemName: "clock")
                            .foregroundColor(.white.opacity(0.6))
                            .font(.system(size: 14))
                        
                        Text("Completed 2 hours ago")
                            .font(.custom("Magistral", size: 14))
                            .foregroundColor(.white.opacity(0.6))
                    }
                }
                
                Spacer()
                
                // Trophy icon
                Image(systemName: "trophy.fill")
                    .foregroundColor(Color.yellow)
                    .font(.system(size: 24))
                    .padding(8)
                    .background(Color.yellow.opacity(0.2))
                    .clipShape(Circle())
            }
            .padding(20)
        }
        .padding(.horizontal, 20)
    }
}

// Progress Circle component
struct ProgressCircleView<Content: View>: View {
    var value: CGFloat
    var color: Color
    var size: CGFloat
    var lineWidth: CGFloat = 8
    @ViewBuilder var content: () -> Content
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(color.opacity(0.2), lineWidth: lineWidth)
                .frame(width: size, height: size)
            
            Circle()
                .trim(from: 0, to: value)
                .stroke(color, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                .frame(width: size, height: size)
                .rotationEffect(.degrees(-90))
            
            content()
        }
    }
}

// Performance Segments View
struct PerformanceSegmentsView: View {
    @Binding var selectedSegment: Int
    var cardBackground: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Performance Segments")
                .font(.custom("Magistral", size: 20))
                .fontWeight(.medium)
                .foregroundColor(.white)
                .padding(.horizontal, 20)
            
            // Segment Tabs
            SegmentTabsView(selectedSegment: $selectedSegment)
            
            // Financial Fundamentals card
            FinancialFundamentalsCardView(cardBackground: cardBackground)
        }
    }
}

// Segment Tabs View
struct SegmentTabsView: View {
    @Binding var selectedSegment: Int
    private let tabs = ["Financial", "Ownership", "Brand"]
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<tabs.count, id: \.self) { index in
                Button(action: {
                    selectedSegment = index
                }) {
                    VStack(spacing: 0) {
                        Text(tabs[index])
                            .font(.custom("Magistral", size: 16))
                            .foregroundColor(index == selectedSegment ? .white : .white.opacity(0.5))
                            .padding(.vertical, 10)
                            .frame(maxWidth: .infinity)
                        
                        // Indicator line for selected tab
                        Rectangle()
                            .fill(index == selectedSegment ? Color.white : Color.clear)
                            .frame(height: 2)
                    }
                }
            }
        }
        .padding(.horizontal, 20)
    }
    
    // Local helper function for tab indexing
    private func getTabIndex(_ tab: String) -> Int {
        switch tab {
        case "Financial": return 0
        case "Ownership": return 1
        case "Brand": return 2
        default: return 0
        }
    }
}

// Financial Fundamentals Card View
struct FinancialFundamentalsCardView: View {
    var cardBackground: Color
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(cardBackground)
                .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
            
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Financial Fundamentals")
                            .font(.custom("Magistral", size: 18))
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                        
                        Text("Sharp Level")
                            .font(.custom("Magistral", size: 14))
                            .foregroundColor(.blue)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 4)
                            .background(Color.blue.opacity(0.2))
                            .cornerRadius(12)
                    }
                    
                    Spacer()
                    
                    // Score circle
                    ProgressCircleView(value: 0.72, color: .blue, size: 60, lineWidth: 6) {
                        Text("72")
                            .font(.custom("Magistral", size: 20))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                }
                
                // Key Insights
                VStack(alignment: .leading, spacing: 12) {
                    Text("Key Insights")
                        .font(.custom("Magistral", size: 16))
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                    
                    // Insights list
                    InsightRow(text: "Strong on investment basics")
                    InsightRow(text: "Developing in tax strategy")
                    InsightRow(text: "Advanced in cash flow management")
                }
            }
            .padding(20)
        }
        .padding(.horizontal, 20)
        .padding(.top, 8)
    }
}

// Performance Ranking View
struct PerformanceRankingView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Performance Ranking")
                .font(.custom("Magistral", size: 20))
                .fontWeight(.medium)
                .foregroundColor(.white)
                .padding(.horizontal, 20)
            
            // Ranking content would go here
            Rectangle()
                .fill(Color.clear)
                .frame(height: 100)
        }
        .padding(.top, 8)
    }
}

// Demo Overlay View
struct DemoOverlayView: View {
    var body: some View {
        VStack {
            Spacer()
            
            VStack(spacing: 16) {
                Image(systemName: "lock.fill")
                    .font(.system(size: 36))
                    .foregroundColor(.white)
                
                Text("Performance Tab Locked")
                    .font(.custom("Magistral", size: 22))
                    .foregroundColor(.white)
                
                Text("This feature will be available in a future update")
                    .font(.custom("Magistral", size: 16))
                    .foregroundColor(.white.opacity(0.7))
                    .multilineTextAlignment(.center)
            }
            .padding(40)
            .frame(maxWidth: .infinity)
            .background(Color.black.opacity(0.85))
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.opacity(0.7))
        .edgesIgnoringSafeArea(.all)
    }
}

struct PerformanceTabView_Previews: PreviewProvider {
    static var previews: some View {
        PerformanceTabView()
    }
}
