import SwiftUI

struct RewardsVaultView: View {
    let rewards: [RewardItem]
    let onInfoPressed: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header with info button
            HStack {
                Text("Rewards Vault")
                    .font(.custom("Magistral", size: 20).bold())
                    .foregroundColor(.white)
                
                Spacer()
                
                Button(action: onInfoPressed) {
                    Image(systemName: "info.circle")
                        .foregroundColor(.white.opacity(0.7))
                        .font(.system(size: 18))
                }
            }
            
            // Fixed 3-item rewards display (no scrolling)
            HStack(spacing: 16) {
                ForEach(rewards) { reward in
                    RewardItemView(reward: reward)
                }
            }
        }
        .padding(20)
        .background(Color.fromHex("#121212"))
        .cornerRadius(16)
    }
}

struct RewardItemView: View {
    let reward: RewardItem
    
    var body: some View {
        VStack(spacing: 10) {
            // Lock/unlock icon
            ZStack {
                Circle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 60, height: 60)
                
                Image(systemName: reward.isUnlocked ? "gift.fill" : "lock.fill")
                    .font(.system(size: 24))
                    .foregroundColor(reward.isUnlocked ? .yellow : .white)
            }
            
            // Reward title
            Text(reward.title)
                .font(.custom("Magistral", size: 14).bold())
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity)
    }
}
