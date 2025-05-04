import SwiftUI

struct WorkoutsTabView: View {
    var body: some View {
        ZStack {
            // Different background color for identification
            Color.fromHex("#211D30").ignoresSafeArea()
            
            VStack {
                Text("Workouts")
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

struct WorkoutsTabView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutsTabView()
    }
}
