import SwiftUI
import Combine
import Foundation

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
                    points: viewModel.points,
                    onPointsTapped: viewModel.showPointsSystemModal
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
                
                // Daily challenge card - conditionally shown
                if viewModel.showDailyChallenge {
                    DailyChallengeCardView(
                        challengeTitle: viewModel.dailyChallengeTitle,
                        progress: viewModel.dailyChallengeProgress,
                        buttonTitle: viewModel.dailyChallengeButtonTitle,
                        onButtonPressed: viewModel.navigateToDailyChallenge
                    )
                    .padding(.horizontal)
                    .transition(.opacity)
                    .animation(.easeInOut, value: viewModel.showDailyChallenge)
                }
                
                // REMOVED: Today's workout paths (wealth/brand)
                // WorkoutPathView(
                //     onWealthSelected: viewModel.navigateToWealthWorkout,
                //     onBrandSelected: viewModel.navigateToBrandWorkout
                // )
                // .padding(.horizontal)
                
                // Featured workouts - replaces Today's Wealth Workout row
                FeaturedGamesListView(
                    games: viewModel.featuredGames,
                    onGameSelected: viewModel.selectFeaturedGame
                )
                
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
                
                // REMOVED: Featured games horizontal scrolling list (moved above)
                // FeaturedGamesListView(
                //     games: viewModel.featuredGames,
                //     onGameSelected: viewModel.selectFeaturedGame
                // )
                
                // REMOVED: Latest articles section with horizontal scrolling
                // ArticlesListView(articles: viewModel.articles)
                
                // REMOVED: Featured videos section with horizontal scrolling
                // VideosListView(videos: viewModel.videos)
                
                // Ownership opportunities section
                OwnershipView(onTap: {
                    // Handle tap to open ownership opportunities detail screen
                    viewModel.showOwnershipOpportunities()
                })
                
                // Safe area for tab bar
                Spacer(minLength: 100)
            }
        }
        .background(Color.fromHex("#0A0A0A"))
        .edgesIgnoringSafeArea(.bottom)
        .overlay(
            ZStack {
                if viewModel.showComingSoonModal {
                    OwnershipModal(isPresented: $viewModel.showComingSoonModal)
                }
                if viewModel.showPointsModal {
                    PointsSystemModal(isPresented: $viewModel.showPointsModal)
                }
            }
        )
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
