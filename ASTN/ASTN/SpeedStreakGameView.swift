import SwiftUI

// MARK: - Game Models
struct FinancialTerm: Identifiable {
    let id = UUID()
    let term: String
    let correctDefinition: String
    let wrongDefinitions: [String]
    
    var allDefinitions: [String] {
        var definitions = wrongDefinitions
        definitions.append(correctDefinition)
        return definitions.shuffled()
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
            correctDefinition: "Net Income Loss",
            wrongDefinitions: ["Name, Image, Likeness", "National Investment League", "Non-Interest Liability"]
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
                // Points display
                HStack {
                    Text("\(points) POINTS")
                        .font(.custom("Magistral", size: 18))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    // Three dots (menu placeholder)
                    HStack(spacing: 8) {
                        ForEach(0..<3, id: \.self) { _ in
                            Circle()
                                .fill(brandGold)
                                .frame(width: 30, height: 30)
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 20)
                
                Spacer()
                
                // Question and answer area
                VStack(spacing: 30) {
                    Text("Define this term")
                        .font(.custom("Magistral", size: 18))
                        .foregroundColor(.white)
                    
                    Text(currentQuestion.term)
                        .font(.custom("Magistral", size: 32))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.bottom, 20)
                    
                    // Answer choices
                    VStack(spacing: 12) {
                        ForEach(currentQuestion.allDefinitions, id: \.self) { definition in
                            Button(action: {
                                if answerStartTime == nil {
                                    answerStartTime = Date()
                                }
                                
                                checkAnswer(definition)
                            }) {
                                Text(definition)
                                    .font(.custom("Magistral", size: 18))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.vertical, 16)
                                    .padding(.horizontal, 20)
                                    .background(
                                        RoundedRectangle(cornerRadius: 4)
                                            .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                                    )
                            }
                            .disabled(showingFeedback)
                        }
                    }
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
            
            // Progress indicator (right side vertical track)
            ZStack(alignment: .trailing) {
                HStack {
                    Spacer()
                    
                    ZStack(alignment: .bottom) {
                        // Track
                        Rectangle()
                            .fill(Color.gray.opacity(0.2))
                            .frame(width: 2)
                            .padding(.vertical, 70)
                        
                        // Up arrow indicator
                        Image(systemName: "arrowtriangle.up.fill")
                            .foregroundColor(.gray.opacity(0.4))
                            .offset(y: -60)
                        
                        // Down arrow indicator
                        Image(systemName: "arrowtriangle.down.fill")
                            .foregroundColor(.gray.opacity(0.4))
                            .offset(y: 60)
                        
                        // F1 Car - moves up with correct answers
                        HStack {
                            // Car body
                            ZStack {
                                // Main body (beige)
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(brandGold)
                                    .frame(width: 40, height: 24)
                                
                                // Blue stripe
                                Rectangle()
                                    .fill(brandBlue)
                                    .frame(width: 36, height: 4)
                            }
                            
                            // Animation effect for correct answers
                            if isAnimating && isCorrect {
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(brandBlue)
                                    .frame(width: 20, height: 40)
                                    .offset(x: -10)
                            }
                        }
                        .offset(y: -carPosition) // Position determined by progress
                        .animation(.spring(response: 0.6), value: carPosition)
                    }
                    .frame(height: UIScreen.main.bounds.height * 0.6)
                    .padding(.trailing, 20)
                }
            }
        }
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarItems(leading: Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            Image(systemName: "chevron.left")
                .foregroundColor(.white)
        })
        .onAppear {
            // Start the first question timer
            answerStartTime = Date()
        }
    }
    
    // Check if the selected answer is correct
    private func checkAnswer(_ selectedDefinition: String) {
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
            
            // Animate the car movement
            withAnimation {
                isAnimating = true
                // Move the car up based on progress through questions
                let progressPerQuestion = UIScreen.main.bounds.height * 0.45 / CGFloat(questions.count)
                carPosition += progressPerQuestion
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
                    currentQuestionIndex += 1
                    answerStartTime = Date() // Reset timer for next question
                }
            } else {
                // Game is over, handle completion
                // For now, just stay on the success message
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
