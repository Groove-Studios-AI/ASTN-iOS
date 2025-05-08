import SwiftUI
import Combine

/// The main dashboard view with all features
struct MainDashboardView: View {
    @StateObject private var viewModel = DashboardViewModel()
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                // Welcome header with user avatar and points
                WelcomeHeaderView(
                    username: viewModel.username,
                    greeting: viewModel.greeting,
                    points: viewModel.points
                )
                .padding(.horizontal)
                .padding(.top, 16)
                
                // Daily streak section
                DailyStreakView(
                    currentStreak: viewModel.currentStreak,
                    maxStreak: viewModel.maxStreak,
                    onCompleteWorkout: viewModel.completeWorkout
                )
                .padding(.horizontal)
                
                // Today's workout paths (wealth/brand)
                WorkoutPathView(
                    onWealthSelected: viewModel.navigateToWealthWorkout,
                    onBrandSelected: viewModel.navigateToBrandWorkout
                )
                .padding(.horizontal)
                
                // Performance tracking preview
                PerformancePreviewView(
                    isOptedIn: $viewModel.isPerformanceTrackingOptedIn
                )
                .padding(.horizontal)
                
                // Rewards vault section - fixed 3 items, no scrolling
                RewardsVaultView(
                    rewards: viewModel.rewards,
                    onInfoPressed: viewModel.showRewardsInfo
                )
                .padding(.horizontal)
                
                // Latest articles section with horizontal scrolling
                ArticlesListView(articles: viewModel.articles)
                
                // Featured videos section with horizontal scrolling
                VideosListView(videos: viewModel.videos)
                
                // Ownership opportunities section (expandable)
                OwnershipView(
                    isExpanded: $viewModel.isOwnershipExpanded,
                    options: viewModel.ownershipOptions,
                    onOptionSelected: viewModel.selectOwnershipOption
                )
                .padding(.horizontal)
                
                // Safe area for tab bar
                Spacer(minLength: 100)
            }
        }
        .background(Color.fromHex("#0A0A0A"))
        .edgesIgnoringSafeArea(.bottom)
        .onAppear {
            viewModel.loadDashboardData()
        }
    }
}

// Preview
struct MainDashboardView_Previews: PreviewProvider {
    static var previews: some View {
        MainDashboardView()
            .preferredColorScheme(.dark)
    }
}
