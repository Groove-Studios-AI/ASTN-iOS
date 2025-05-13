import SwiftUI
import Combine

struct OnboardingStep1View: View {
    // Callback when the user continues to the next step
    var onContinue: (AthleteType, String, String, String) -> Void
    
    // State for selections
    @State private var selectedAthleteType: AthleteType?
    @State private var selectedSport: String = ""
    @State private var customSport: String = ""
    @State private var showSportsList: Bool = false
    @State private var showSportTextField: Bool = false
    @State private var dateOfBirth = Date()
    @State private var showDatePicker = false
    @State private var phoneNumber: String = ""
    
    // Date formatter for display and API submission
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
    
    // Date formatter for API
    private let apiDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    // Sample sports list
    private let sports = [
        "American Football", "Basketball", "Baseball", "Soccer", "Ice Hockey", 
        "Tennis", "Golf", "Other"
    ]
    
    // Colors
    private let brandBlue = Color.fromHex("#1A2196")
    private let brandBlack = Color.fromHex("#0A0A0A")
    
    // Form validation
    private var isFormValid: Bool {
        let sportValid = selectedSport != "Other" ? !selectedSport.isEmpty : !customSport.isEmpty
        return selectedAthleteType != nil && sportValid && !phoneNumber.isEmpty
    }
    
    // Get the final sport value (either selected or custom)
    private var finalSportValue: String {
        return selectedSport == "Other" ? customSport : selectedSport
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
                                    ? brandBlue
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
                    
                    ZStack {
                        // Sport Selection Button
                        if !showSportTextField {
                            Button(action: {
                                showSportsList.toggle()
                            }) {
                                HStack {
                                    Text(selectedSport.isEmpty ? "Sport" : selectedSport)
                                        .font(.custom("Magistral", size: 16))
                                        .foregroundColor(selectedSport.isEmpty ? .gray : .white)
                                        .padding(.leading, 16)
                                    
                                    Spacer()
                                    
                                    Image(systemName: showSportsList ? "chevron.up" : "chevron.down")
                                        .foregroundColor(.white.opacity(0.7))
                                        .padding(.trailing, 16)
                                }
                                .frame(height: 56)
                                .frame(maxWidth: .infinity)
                                .background(!selectedSport.isEmpty ? brandBlue : Color.white.opacity(0.1))
                                .cornerRadius(8)
                            }
                        }
                        
                        // Text field for custom sport if "Other" is selected
                        if showSportTextField {
                            HStack {
                                TextField("", text: $customSport)
                                    .font(.custom("Magistral", size: 16))
                                    .foregroundColor(.white)
                                    .placeholder(when: customSport.isEmpty) {
                                        Text("Enter your sport")
                                            .font(.custom("Magistral", size: 16))
                                            .foregroundColor(.gray)
                                    }
                                    .padding(.leading, 16)
                                
                                // Button to return to sport selection
                                Button(action: {
                                    showSportsList = true
                                }) {
                                    Image(systemName: "chevron.down")
                                        .foregroundColor(.white.opacity(0.7))
                                        .padding(10)
                                }
                                .padding(.trailing, 6)
                            }
                            .frame(height: 56)
                            .background(!customSport.isEmpty ? brandBlue : Color.white.opacity(0.1))
                            .cornerRadius(8)
                        }
                    }
                    
                    // Custom sports list dropdown
                    if showSportsList {
                        VStack(spacing: 0) {
                            ForEach(sports, id: \.self) { sport in
                                Button(action: {
                                    selectedSport = sport
                                    showSportsList = false
                                    
                                    if sport == "Other" {
                                        showSportTextField = true
                                    } else {
                                        showSportTextField = false
                                        customSport = ""
                                    }
                                }) {
                                    HStack {
                                        Text(sport)
                                            .font(.custom("Magistral", size: 16))
                                            .foregroundColor(.white)
                                            .padding(.leading, 20)
                                        Spacer()
                                    }
                                    .frame(height: 56)
                                    .frame(maxWidth: .infinity)
                                    .background(selectedSport == sport ? brandBlue : Color(hex: "#1A1A1A"))
                                }
                                if sport != sports.last {
                                    Divider()
                                        .background(Color.gray.opacity(0.3))
                                        .padding(.horizontal, 8)
                                }
                            }
                        }
                        .background(Color(hex: "#1A1A1A"))
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.white.opacity(0.1), lineWidth: 1)
                        )
                    }
                }
                .padding(.bottom, 24)
                
                // Date of Birth
                VStack(alignment: .leading, spacing: 10) {
                    Text("Date of Birth")
                        .font(.custom("Magistral", size: 16))
                        .foregroundColor(.white.opacity(0.7))
                    
                    Button(action: {
                        // Show date picker when field is tapped
                        showDatePicker = true
                    }) {
                        HStack {
                            Text(dateFormatter.string(from: dateOfBirth))
                                .font(.custom("Magistral", size: 16))
                                .foregroundColor(.white)
                                .padding(.leading, 16)
                            
                            Spacer()
                            
                            Image(systemName: "calendar")
                                .foregroundColor(.white.opacity(0.7))
                                .padding(.trailing, 16)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(brandBlue)
                        .cornerRadius(8)
                    }
                    
                    // Date Picker (shown as a sheet when button is tapped)
                    .sheet(isPresented: $showDatePicker) {
                        VStack {
                            HStack {
                                Button("Cancel") {
                                    showDatePicker = false
                                }
                                .padding()
                                
                                Spacer()
                                
                                Button("Done") {
                                    showDatePicker = false
                                }
                                .padding()
                                .bold()
                            }
                            
                            DatePicker("", selection: $dateOfBirth, in: ...Date(), displayedComponents: .date)
                                .datePickerStyle(WheelDatePickerStyle())
                                .labelsHidden()
                                .frame(maxWidth: .infinity)
                                .padding()
                        }
                        .background(Color(.systemBackground))
                        .presentationDetents([.height(300)])
                    }
                }
                .padding(.bottom, 24)
                
                // Phone Number
                VStack(alignment: .leading, spacing: 10) {
                    Text("Phone Number (Password Retrieval)")
                        .font(.custom("Magistral", size: 16))
                        .foregroundColor(.white.opacity(0.7))
                    
                    TextField("", text: $phoneNumber)
                        .font(.custom("Magistral", size: 16))
                        .foregroundColor(.white)
                        .placeholder(when: phoneNumber.isEmpty) {
                            Text("(123) 456-7890")
                                .font(.custom("Magistral", size: 16))
                                .foregroundColor(.gray)
                                .padding(.leading, 16)
                        }
                        .padding()
                        .background(!phoneNumber.isEmpty ? brandBlue : Color.white.opacity(0.1))
                        .cornerRadius(8)
                        .keyboardType(.phonePad)
                }
                .padding(.bottom, 24)
                
                // Continue button
                Button(action: {
                    if let athleteType = selectedAthleteType, isFormValid {
                        // Format date as string for API
                        let formattedDate = apiDateFormatter.string(from: dateOfBirth)
                        onContinue(athleteType, finalSportValue, formattedDate, phoneNumber)
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
            OnboardingStep1View(onContinue: { _, _, _, _ in })
        }
    }
}
