import UIKit

extension UINavigationBar {
    /// Configure navigation bar appearance to prevent color changes during scrolling
    static func configureAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(named: "NavBarBackground") ?? .systemBackground
        
        // Title text attributes
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor(named: "NavBarText") ?? .label
        ]
        
        // Setup for all navigation bars
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        
        // Ensure the tint color is set properly for bar button items
        UINavigationBar.appearance().tintColor = UIColor(named: "AccentColor") ?? .systemBlue
    }
}
