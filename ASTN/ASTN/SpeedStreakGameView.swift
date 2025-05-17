import SwiftUI

// MARK: - Game Models
struct FinancialTerm: Identifiable {
    let id = UUID()
    let term: String
    let correctDefinition: String
    let wrongDefinitions: [String]
    
    // Original function for backward compatibility
    var allDefinitions: [String] {
        var definitions = wrongDefinitions
        definitions.append(correctDefinition)
        return definitions.shuffled()
    }
    
    // Get exactly two options for the design
    var twoOptions: [String] {
        // Get first wrong definition or use a default if empty
        let wrongOption = wrongDefinitions.first ?? "Unknown"
        return [correctDefinition, wrongOption].shuffled()
    }
}

// MARK: - Speed Streak Game View
struct SpeedStreakGameView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var points = 0
    @State private var currentQuestionIndex = 0
    @State private var selectedAnswer: String? = nil
    @State private var isCorrect = false
    @State private var showingFeedback = false
    @State private var speedBonus = 0
    @State private var carPosition: CGFloat = 0
    @State private var answerStartTime: Date? = nil
    @State private var isAnimating = false
    
    // Demo questions (these would come from your data model in production)
    private let questions = [
        FinancialTerm(
            term: "NIL",
            correctDefinition: "Name, Image, Likeness",
            wrongDefinitions: ["Net Income Loss", "National Investment League", "Non-Interest Liability"]
        ),
        FinancialTerm(
            term: "APR",
            correctDefinition: "Annual Percentage Rate",
            wrongDefinitions: ["Asset Protection Reserve", "Adjusted Payment Ratio", "Automated Payment Return"]
        ),
        FinancialTerm(
            term: "ETF",
            correctDefinition: "Exchange Traded Fund",
            wrongDefinitions: ["Electronic Transfer Fee", "Equity Trust Fund", "Emerging Technology Financing"]
        ),
        FinancialTerm(
            term: "ROI",
            correctDefinition: "Return On Investment",
            wrongDefinitions: ["Risk Of Inflation", "Revenue Operating Index", "Retirement Option Insurance"]
        ),
        FinancialTerm(
            term: "IRA",
            correctDefinition: "Individual Retirement Account",
            wrongDefinitions: ["Interest Rate Adjustment", "Investment Revenue Allocation", "Income Reporting Application"]
        )
    ]
    
    private var currentQuestion: FinancialTerm {
        questions[min(currentQuestionIndex, questions.count - 1)]
    }
    
    // Brand colors
    private let brandBlue = Color.fromHex("#1A2196")
    private let brandGold = Color.fromHex("#E8D5B5")
    private let brandGreen = Color.fromHex("#23512A") // Dark green for success message
    
    var body: some View {
        ZStack {
            // Background
            Color.black.edgesIgnoringSafeArea(.all)
            
            // Main content
            VStack(spacing: 0) {
                // Enhanced header with points and title
                VStack(spacing: 12) {
                    HStack {
                        Text("\(points) Points")
                            .font(.custom("Magistral", size: 18))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        // Blue dots progress indicator
                        HStack(spacing: 6) {
                            ForEach(0..<5, id: \.self) { index in
                                Circle()
                                    .fill(index < currentQuestionIndex + 1 ? brandBlue : brandBlue.opacity(0.3))
                                    .frame(width: 20, height: 20)
                            }
                        }
                    }
                    
                    HStack {
                        Text("Brand Readiness")
                            .font(.custom("Magistral", size: 24))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Spacer()
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 20)
                
                Spacer()
                
                // Question and answer area - styled for design
                VStack(spacing: 40) {
                    Text("Define this term")
                        .font(.custom("Magistral", size: 18))
                        .foregroundColor(.white)
                        .padding(.top, 20)
                    
                    Text(currentQuestion.term)
                        .font(.custom("Magistral", size: 40)) // Larger font per design
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.bottom, 40) // More spacing per design
                    
                    // Answer choices - only 2 per design matching screenshot
                    VStack(spacing: 20) { // Increased spacing between options
                        ForEach(currentQuestion.twoOptions, id: \.self) { definition in
                            Button(action: {
                                checkAnswer(definition)
                            }) {
                                Text(definition)
                                    .font(.custom("Magistral", size: 18))
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(.white) // Always white text
                                    .padding(.vertical, 16)
                                    .frame(maxWidth: .infinity)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(brandGold, lineWidth: 1) // Thinner gold border
                                            .background(
                                                RoundedRectangle(cornerRadius: 8)
                                                    .fill(Color.black) // Black background
                                            )
                                    )
                            }
                            .disabled(selectedAnswer != nil)
                        }
                    }
                    .padding(.top, 20) // More space between term and options
                    .padding(.horizontal, 20)
                }
                
                Spacer()
                
                // Feedback overlay (shows when answer is selected)
                if showingFeedback {
                    VStack {
                        Spacer()
                        
                        HStack {
                            if isCorrect {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.white)
                                
                                Text("Correct!")
                                    .font(.custom("Magistral", size: 18))
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                            } else {
                                Image(systemName: "xmark")
                                    .foregroundColor(.white)
                                
                                Text("Wrong!")
                                    .font(.custom("Magistral", size: 18))
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                            }
                        }
                        
                        if isCorrect {
                            Text("Correct! +10 points (+\(speedBonus) speed bonus)")
                                .font(.custom("Magistral", size: 16))
                                .foregroundColor(.white.opacity(0.8))
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(isCorrect ? brandGreen : Color.red.opacity(0.8))
                    .transition(.move(edge: .bottom))
                }
            }
            
            // Position the ProgressTrackView at the trailing edge
            GeometryReader { geometry in
                HStack(spacing: 0) {
                    Spacer() // Push to trailing edge
                    
                    // Progress track with asset images
                    ProgressTrackView(
                        progress: CGFloat(currentQuestionIndex) / CGFloat(max(1, questions.count - 1)),
                        isAnimating: isAnimating
                    )
                    .frame(height: geometry.size.height * 1.0) // Match the parent height
                    .padding(.trailing, 10) // Slight padding from edge
                    .padding(.top, -30) // Adjust to align with blue dots
                }
            }
        }
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarItems(leading: Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            HStack {
                Image(systemName: "chevron.left")
                    .foregroundColor(brandGold)
                Text("Back")
                    .foregroundColor(brandGold)
                    .font(.custom("Magistral", size: 16))
            }
        })
        // No custom tab bar needed since the system already shows one
        .onAppear {
            // Start the first question timer
            answerStartTime = Date()
        }
    }
    
    // Check if the selected answer is correct
    private func checkAnswer(_ selectedDefinition: String) {
        // Prevent multiple selections for the same question
        guard selectedAnswer == nil else { return }
        
        // Set the selected answer and check if correct
        selectedAnswer = selectedDefinition
        isCorrect = (selectedDefinition == currentQuestion.correctDefinition)
        
        // Calculate speed bonus if correct (based on response time)
        if isCorrect, let startTime = answerStartTime {
            let timeTaken = Date().timeIntervalSince(startTime)
            
            // Award speed bonus based on response time
            if timeTaken < 2.0 {
                speedBonus = 5
            } else if timeTaken < 4.0 {
                speedBonus = 3
            } else if timeTaken < 6.0 {
                speedBonus = 1
            } else {
                speedBonus = 0
            }
            
            // Add points
            points += 10 + speedBonus
            
            // Update progress value (still using carPosition for state tracking)
            // This will now be used by the ProgressTrackView through the progress ratio calculation
            withAnimation {
                isAnimating = true
                carPosition = CGFloat(currentQuestionIndex + 1) // Increment progress counter
            }
        }
        
        // Show feedback
        withAnimation {
            showingFeedback = true
        }
        
        // After a delay, move to the next question
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            if currentQuestionIndex < questions.count - 1 {
                withAnimation {
                    showingFeedback = false
                    isAnimating = false
                    selectedAnswer = nil // Reset selected answer
                    currentQuestionIndex += 1
                    answerStartTime = Date() // Reset timer for next question
                }
            } else {
                // Game is over, handle completion
                withAnimation {
                    showingFeedback = false
                }
                // Could navigate to results screen or back to workout list
            }
        }
    }
}

// MARK: - Preview
struct SpeedStreakGameView_Previews: PreviewProvider {
    static var previews: some View {
        SpeedStreakGameView()
            .preferredColorScheme(.dark)
    }
}
