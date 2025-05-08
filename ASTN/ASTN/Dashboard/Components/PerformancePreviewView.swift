import SwiftUI

struct PerformancePreviewView: View {
    @Binding var isOptedIn: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Performance Tracking Coming Soon")
                .font(.custom("Magistral", size: 18).bold())
                .foregroundColor(.white)
            
            Text("Unlock advanced performance metrics as more athletes join the platform.")
                .font(.custom("Magistral", size: 14))
                .foregroundColor(.white.opacity(0.7))
                .multilineTextAlignment(.leading)
            
            // Opt-in toggle
            HStack {
                Button(action: {
                    isOptedIn.toggle()
                }) {
                    HStack(spacing: 10) {
                        // Custom checkbox
                        ZStack {
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(Color.white.opacity(0.6), lineWidth: 1)
                                .frame(width: 20, height: 20)
                            
                            if isOptedIn {
                                Image(systemName: "checkmark")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(.white)
                            }
                        }
                        
                        Text("I want this feature")
                            .font(.custom("Magistral", size: 14))
                            .foregroundColor(.white)
                    }
                }
                
                Spacer()
            }
            .padding(.top, 4)
        }
        .padding(20)
        .background(Color.fromHex("#121212"))
        .cornerRadius(16)
    }
}
