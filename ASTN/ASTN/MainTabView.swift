import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    
    // Brand colors
    private let brandBlue = Color.fromHex("#1A2196")
    
    var body: some View {
        TabView(selection: $selectedTab) {
            DashboardTabView()
                .tabItem {
                    Image("dash_tabIcon")
                    Text("Dashboard")
                }
                .tag(0)
            
            PerformanceTabView()
                .tabItem {
                    Image("Performance_tabIcon")
                    Text("Performance")
                }
                .tag(1)
            
            WorkoutsTabView()
                .tabItem {
                    Image("workouts_tabIcon")
                    Text("Workouts")
                }
                .tag(2)
            
            ProfileTabView()
                .tabItem {
                    Image(systemName: "person.circle.fill")
                    Text("Profile")
                }
                .tag(3)
        }
        .accentColor(brandBlue) // Selected tab color
        .modifier(TabIconModifier()) // Apply our custom tab icon modifier
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
