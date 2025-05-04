import SwiftUI

struct DashboardTabView: View {
    var body: some View {
        ZStack {
            // Different background color for identification
            Color.fromHex("#0A0A0A").ignoresSafeArea()
            
            VStack {
                Text("Dashboard")
                    .font(.custom("Magistral", size: 30))
                    .foregroundColor(.white)
                    .padding()
                
                Text("Coming Soon")
                    .font(.custom("Magistral", size: 18))
                    .foregroundColor(.white)
            }
        }
    }
}

struct DashboardTabView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardTabView()
    }
}
