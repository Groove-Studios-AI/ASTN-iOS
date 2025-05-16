import SwiftUI

// A view modifier that configures tab bar images to be exactly 24x24 points
struct TabIconModifier: ViewModifier {
    let iconSize: CGFloat = 24.0
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                // Configure tab bar images to be exactly 24x24 points
                let tabBarAppearance = UITabBarAppearance()
                tabBarAppearance.configureWithDefaultBackground()
                tabBarAppearance.backgroundColor = UIColor(Color.fromHex("#0A0A0A"))
                
                // This affects the icon size
                UITabBar.appearance().itemPositioning = .centered
                
                // Configure for specific layouts
                let itemAppearance = UITabBarItemAppearance()
                
                // CRITICAL: Ensure we're using Magistral font at exactly 11px
                let magistralFont = UIFont(name: "Magistral", size: 11) ?? UIFont.systemFont(ofSize: 11)
                
                // Set unselected tab color to white
                itemAppearance.normal.iconColor = .white
                itemAppearance.normal.titleTextAttributes = [
                    NSAttributedString.Key.foregroundColor: UIColor.white,
                    NSAttributedString.Key.font: magistralFont
                ]
                
                // Set selected tab color to champagne/gold
                let brandGoldUIColor = UIColor(Color.fromHex("#E8D5B5"))
                itemAppearance.selected.iconColor = brandGoldUIColor
                itemAppearance.selected.titleTextAttributes = [
                    NSAttributedString.Key.foregroundColor: brandGoldUIColor,
                    NSAttributedString.Key.font: magistralFont
                ]
                
                // Apply to all tab bar layouts
                tabBarAppearance.stackedLayoutAppearance = itemAppearance
                tabBarAppearance.inlineLayoutAppearance = itemAppearance
                tabBarAppearance.compactInlineLayoutAppearance = itemAppearance
                
                // Directly apply the appearance to ensure color settings are used
                UITabBar.appearance().standardAppearance = tabBarAppearance
                UITabBar.appearance().unselectedItemTintColor = .white
                UITabBar.appearance().tintColor = brandGoldUIColor
                
                if #available(iOS 15.0, *) {
                    UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
                }
                
                // Fix icon size using representation sizes
                let tabBarItems = UITabBar.appearance().items
                tabBarItems?.forEach { item in
                    // Set title font for both states
                    item.setTitleTextAttributes([
                        NSAttributedString.Key.font: magistralFont
                    ], for: .normal)
                    
                    item.setTitleTextAttributes([
                        NSAttributedString.Key.font: magistralFont
                    ], for: .selected)
                    
                    // Scale down tab bar icons
                    if let image = item.image {
                        let resizedImage = resizeImage(image: image, targetSize: CGSize(width: iconSize, height: iconSize))
                        item.image = resizedImage.withRenderingMode(.alwaysTemplate)
                    }
                    if let selectedImage = item.selectedImage {
                        let resizedImage = resizeImage(image: selectedImage, targetSize: CGSize(width: iconSize, height: iconSize))
                        item.selectedImage = resizedImage.withRenderingMode(.alwaysTemplate)
                    }
                }
            }
    }
    
    // Helper to resize UIImage
    private func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage ?? image
    }
}
