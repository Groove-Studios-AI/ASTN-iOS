import SwiftUI

struct OnboardingStep1View: View {
    // Callback when the user continues to the next step
    var onContinue: (AthleteType, String) -> Void
    
    // State for selections
    @State private var selectedAthleteType: AthleteType?
    @State private var selectedSport: String = ""
    
    // Sample sports list
    private let sports = [
        "Basketball", "Football", "Baseball", "Soccer", "Tennis", 
        "Golf", "Swimming", "Track & Field", "Volleyball", "Gymnastics",
        "Hockey", "Boxing", "MMA", "Wrestling", "Skiing",
        "Snowboarding", "Skateboarding", "Surfing", "Rugby", "Cricket"
    ]
    
    // Colors
    private let brandBlue = Color.fromHex("#1A2196")
    private let brandBlack = Color.fromHex("#0A0A0A")
    
    // Form validation
    private var isFormValid: Bool {
        selectedAthleteType != nil && !selectedSport.isEmpty
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Progress indicator
                ProgressIndicator(currentStep: 1, totalSteps: 3)
                    .padding(.bottom, 5)
                
                // Main heading
                Text("Tell us a bit about yourself")
                    .font(.custom("Magistral", size: 28))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.bottom, 5)
                
                // Occupation/Role section
                VStack(alignment: .leading, spacing: 10) {
                    Text("Occupation or Role (Select Current Status)")
                        .font(.custom("Magistral", size: 16))
                        .foregroundColor(.white.opacity(0.7))
                    
                    // Athlete type selection buttons
                    VStack(spacing: 12) {
                        ForEach(AthleteType.allCases, id: \.self) { athleteType in
                            Button(action: {
                                selectedAthleteType = athleteType
                            }) {
                                HStack {
                                    Text(athleteType.rawValue)
                                        .font(.custom("Magistral", size: 16))
                                        .foregroundColor(.white)
                                        .padding(.leading, 16)
                                    
                                    Spacer()
                                }
                                .frame(height: 56)
                                .frame(maxWidth: .infinity)
                                .background(
                                    selectedAthleteType == athleteType 
                                    ? Color.white.opacity(0.2) 
                                    : Color.white.opacity(0.1)
                                )
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(
                                            selectedAthleteType == athleteType 
                                            ? Color.white.opacity(0.5) 
                                            : Color.clear, 
                                            lineWidth: 1
                                        )
                                )
                            }
                        }
                    }
                }
                .padding(.bottom, 24)
                
                // Sport selection
                VStack(alignment: .leading, spacing: 10) {
                    Text("Sport")
                        .font(.custom("Magistral", size: 16))
                        .foregroundColor(.white.opacity(0.7))
                    
                    Menu {
                        ForEach(sports, id: \.self) { sport in
                            Button(sport) {
                                selectedSport = sport
                            }
                        }
                    } label: {
                        HStack {
                            Text(selectedSport.isEmpty ? "Sport" : selectedSport)
                                .font(.custom("Magistral", size: 16))
                                .foregroundColor(selectedSport.isEmpty ? .gray : .white)
                                .padding(.leading, 16)
                            
                            Spacer()
                            
                            Image(systemName: "chevron.down")
                                .foregroundColor(.white.opacity(0.7))
                                .padding(.trailing, 16)
                        }
                        .frame(height: 56)
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(8)
                    }
                }
                
                Spacer()
                
                // Continue button
                Button(action: {
                    if let athleteType = selectedAthleteType, !selectedSport.isEmpty {
                        onContinue(athleteType, selectedSport)
                    }
                }) {
                    HStack {
                        Text("Continue")
                            .font(.custom("Magistral", size: 18))
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Image(systemName: "arrow.right")
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 24)
                    .frame(height: 56)
                    .frame(maxWidth: .infinity)
                    .background(isFormValid ? brandBlue : brandBlue.opacity(0.5))
                    .cornerRadius(8)
                }
                .disabled(!isFormValid)
                .padding(.top, 16)
            }
            .padding([.horizontal, .bottom], 24)
        }
    }
}

// Extension to make AthleteType enumerable for UI purposes
extension AthleteType: CaseIterable {
    public static var allCases: [AthleteType] {
        return [.professional, .college, .highSchool, .retired, .amateur, .paralympic, .eSports]
    }
}

// Preview for development
struct OnboardingStep1View_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            OnboardingStep1View(onContinue: { _, _ in })
        }
    }
}
