import Foundation

struct RewardItem: Identifiable {
    let id: String
    let title: String
    let isUnlocked: Bool
}

struct Article: Identifiable {
    let id: String
    let title: String
    let previewText: String
    let imageURL: URL?
    let readTimeMinutes: Int
    let isEditorsChoice: Bool
}

struct Video: Identifiable {
    let id: String
    let title: String
    let description: String
    let thumbnailURL: URL?
    let durationMinutes: Int
    let isPremium: Bool
}

struct OwnershipOption: Identifiable {
    let id: String
    let title: String
    let description: String
    let iconName: String
}
