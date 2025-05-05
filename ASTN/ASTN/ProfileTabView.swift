import SwiftUI

struct ProfileTabView: View {
    var body: some View {
        ZStack {
            // Different background color for identification
            Color.fromHex("#30201D").ignoresSafeArea()
            
            VStack {
                Text("Profile")
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

struct ProfileTabView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileTabView()
    }
}
