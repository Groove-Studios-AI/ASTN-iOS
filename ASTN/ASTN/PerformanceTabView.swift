import SwiftUI

struct PerformanceTabView: View {
    var body: some View {
        ZStack {
            // Different background color for identification
            Color.fromHex("#1E2130").ignoresSafeArea()
            
            VStack {
                Text("Performance")
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

struct PerformanceTabView_Previews: PreviewProvider {
    static var previews: some View {
        PerformanceTabView()
    }
}
