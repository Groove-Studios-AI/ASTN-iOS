import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    
    // Brand colors
    private let brandBlue = Color.fromHex("#1A2196")
    
    var body: some View {
        TabView(selection: $selectedTab) {
            DashboardTabView()
                .tabItem {
                    Label {
                        Text("Dashboard")
                            .font(.custom("Magistral", size: 11))
                    } icon: {
                        Image("dash_tabIcon")
                            .renderingMode(.template)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                    }
                }
                .tag(0)
            
            PerformanceTabView()
                .tabItem {
                    Label {
                        Text("Performance")
                            .font(.custom("Magistral", size: 11))
                    } icon: {
                        Image("Performance_tabIcon")
                            .renderingMode(.template)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                    }
                }
                .tag(1)
            
            WorkoutsTabView()
                .tabItem {
                    Label {
                        Text("Workouts")
                            .font(.custom("Magistral", size: 11))
                    } icon: {
                        Image("workouts_tabIcon")
                            .renderingMode(.template)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                    }
                }
                .tag(2)
            
            ProfileTabView()
                .tabItem {
                    Label {
                        Text("Profile")
                            .font(.custom("Magistral", size: 11))
                    } icon: {
                        // For profile tab, using a system icon as placeholder for now
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                    }
                }
                .tag(3)
        }
        .accentColor(brandBlue) // Selected tab color
        .onAppear {
            // Set the tab bar appearance
            let appearance = UITabBarAppearance()
            appearance.backgroundColor = UIColor(Color.fromHex("#0A0A0A"))
            
            // Configure the tab bar item appearance
            let itemAppearance = UITabBarItemAppearance()
            
            // Set unselected tab color to white
            itemAppearance.normal.iconColor = .white
            itemAppearance.normal.titleTextAttributes = [
                NSAttributedString.Key.foregroundColor: UIColor.white,
                NSAttributedString.Key.font: UIFont(name: "Magistral", size: 11) ?? UIFont.systemFont(ofSize: 11)
            ]
            
            // Set selected tab color to brand blue
            let brandBlueUIColor = UIColor(red: 26/255, green: 33/255, blue: 150/255, alpha: 1.0)
            itemAppearance.selected.iconColor = brandBlueUIColor
            itemAppearance.selected.titleTextAttributes = [
                NSAttributedString.Key.foregroundColor: brandBlueUIColor,
                NSAttributedString.Key.font: UIFont(name: "Magistral", size: 11) ?? UIFont.systemFont(ofSize: 11)
            ]
            
            // Apply the item appearance to all tab bar appearances
            appearance.stackedLayoutAppearance = itemAppearance
            appearance.inlineLayoutAppearance = itemAppearance
            appearance.compactInlineLayoutAppearance = itemAppearance
            
            // Apply the appearance to the tab bar
            UITabBar.appearance().standardAppearance = appearance
            if #available(iOS 15.0, *) {
                UITabBar.appearance().scrollEdgeAppearance = appearance
            }
        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
