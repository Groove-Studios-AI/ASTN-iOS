import SwiftUI

/// The Dashboard Tab View that integrates with the existing tab structure
struct DashboardTabView: View {
    var body: some View {
        MainDashboardView()
    }
}

// Preview
struct DashboardTabView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardTabView()
            .preferredColorScheme(.dark)
    }
}
