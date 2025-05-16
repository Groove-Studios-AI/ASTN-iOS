import SwiftUI

struct GamePreviewQuestionView: View {
    // Callback when the user continues to the next step
    var onContinue: () -> Void
    
    // State for selections
    @State private var selectedOption: String? = nil
    
    // Colors
    private let brandBlack = Color.fromHex("#0A0A0A")
    private let brandBlue = Color.fromHex("#1A2196")
    private let brandWhite = Color.fromHex("#F7F5F6")
    
    // Sample question and options
    private let question = "What part of the sentence is unnecessary?"
    private let sentence = "\"The tornado completely destroyed our roof.\""
    private let options = ["tornado", "completely", "our"]
    
    var body: some View {
        ZStack {
            // Background
            brandBlack.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                // Header with ASTN Logo
                HStack {
                    Spacer()
                    Image("ASTN_LaunchLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 40)
                    Spacer()
                }
                .padding(.top, 16)
                .padding(.bottom, 16)
                
                // Progress indicator
                ZStack(alignment: .leading) {
                    // Background track
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 3)
                    
                    // Blue progress indicator - 50% progress
                    Rectangle()
                        .fill(brandBlue)
                        .frame(width: UIScreen.main.bounds.width * 0.50, height: 3)
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 40)
                
                // Question
                Text(question)
                    .font(.custom("Magistral", size: 22))
                    .fontWeight(.bold)
                    .foregroundColor(brandWhite)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
                    .padding(.bottom, 24)
                
                // Sentence
                Text(sentence)
                    .font(.custom("Magistral", size: 18))
                    .foregroundColor(brandWhite)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
                    .padding(.bottom, 32)
                
                // Answer options
                VStack(spacing: 16) {
                    ForEach(options, id: \.self) { option in
                        Button(action: {
                            selectedOption = option
                        }) {
                            HStack {
                                Text(option)
                                    .font(.custom("Magistral", size: 16))
                                    .foregroundColor(brandWhite)
                                
                                Spacer()
                            }
                            .padding(.leading, 24)
                            .frame(height: 56)
                            .frame(maxWidth: .infinity)
                            .background(
                                selectedOption == option ? brandBlue : Color.black.opacity(0.3)
                            )
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(
                                        selectedOption == option ? brandWhite.opacity(0.5) : Color.clear,
                                        lineWidth: 1
                                    )
                            )
                        }
                        .padding(.horizontal, 24)
                    }
                }
                .padding(.bottom, 24)
                
                // Hint
                HStack(spacing: 12) {
                    Circle()
                        .fill(Color.fromHex("#D6C7A9")) // Gold/beige color
                        .frame(width: 24, height: 24)
                        .overlay(
                            Text("0")
                                .font(.custom("Magistral", size: 14))
                                .foregroundColor(.black)
                        )
                    
                    Text("Choose the redundant word")
                        .font(.custom("Magistral", size: 16))
                        .foregroundColor(brandWhite.opacity(0.8))
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 32)
                
                Spacer()
                
                // Continue button - only enabled if an option is selected
                Button(action: {
                    if selectedOption != nil {
                        onContinue()
                    }
                }) {
                    Text("Continue")
                        .font(.custom("Magistral", size: 18))
                        .fontWeight(.medium)
                        .foregroundColor(brandWhite)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(selectedOption != nil ? brandBlue : brandBlue.opacity(0.5))
                        .cornerRadius(8)
                }
                .disabled(selectedOption == nil)
                .padding(.horizontal, 24)
                .padding(.bottom, 32)
            }
        }
    }
}

#Preview {
    GamePreviewQuestionView(onContinue: {})
}
