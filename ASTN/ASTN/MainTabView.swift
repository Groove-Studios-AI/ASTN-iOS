import SwiftUI
import Combine

struct MainTabView: View {
    @EnvironmentObject var appState: AppState
    
    // Brand colors
    private let brandBlue = Color.fromHex("#1A2196")
    private let brandGold = Color.fromHex("#E8D5B5")  // Champagne color
    
    var body: some View {
        TabView(selection: $appState.selectedTabIndex) {
            DashboardTabView()
                .tabItem {
                    Image("dash_tabIcon")
                        .renderingMode(.template)
                    Text("Dashboard")
                }
                .tag(0)
            
            PerformanceTabView()
                .tabItem {
                    Image("performanceTab")
                        .renderingMode(.template)
                    Text("Performance")
                }
                .tag(1)
            
            WorkoutsTabView()
                .tabItem {
                    Image("target")
                        .renderingMode(.template)
                    Text("Reps")
                }
                .tag(2)
            
            ProfileTabView()
                .tabItem {
                    Image(systemName: "person.circle.fill")
                    Text("Profile")
                }
                .tag(3)
        }
        .accentColor(brandGold) // Selected tab color
        .modifier(TabIconModifier()) // Apply our custom tab icon modifier
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
