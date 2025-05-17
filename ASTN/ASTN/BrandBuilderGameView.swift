import SwiftUI

// MARK: - Brand Question Model
struct BrandQuestion: Identifiable {
    let id = UUID()
    let questionStart: String
    let questionBlank: String
    let questionEnd: String
    let correctAnswer: String
    let incorrectAnswer: String
    
    // Options array derived from correct and incorrect answers
    var options: [String] {
        return [correctAnswer, incorrectAnswer].shuffled()
    }
    
    // Full sentence combining all parts
    var fullQuestion: String {
        return "\(questionStart) \(correctAnswer) \(questionEnd)"
    }
}

// MARK: - Brand Builder Game View
struct BrandBuilderGameView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var points = 0
    @State private var currentQuestionIndex = 0
    @State private var selectedAnswer: String? = nil
    @State private var isCorrect = false
    @State private var showingFeedback = false
    @State private var showingNextQuestion = false
    @State private var answerStartTime: Date? = nil
    @State private var speedyAnswersCount = 0
    @State private var remainingLives = 4 // Starting lives
    
    // MARK: - Game Flow Coordinator
    @StateObject private var flowCoordinator = GameFlowCoordinator()
    
    // Brand colors
    private let brandBlack = Color.fromHex("#0A0A0A")
    private let brandBlue = Color.fromHex("#1A2196")
    private let brandGold = Color.fromHex("#E8D5B5")
    private let brandWhite = Color.white
    private let brandGreen = Color.fromHex("#23512A") // Dark green for success message
    
    // Sample questions (these would come from your data model in production)
    private let questions = [
        BrandQuestion(
            questionStart: "An athlete's personal",
            questionBlank: "_______",
            questionEnd: "is how the public perceives them beyond their sport.",
            correctAnswer: "Brand",
            incorrectAnswer: "Contract"
        ),
        BrandQuestion(
            questionStart: "Athletes who consistently",
            questionBlank: "_______",
            questionEnd: "content have stronger social media engagement.",
            correctAnswer: "Create",
            incorrectAnswer: "Share"
        ),
        BrandQuestion(
            questionStart: "A strong personal brand can lead to",
            questionBlank: "_______",
            questionEnd: "opportunities beyond your playing career.",
            correctAnswer: "Endorsement",
            incorrectAnswer: "Coaching"
        ),
        BrandQuestion(
            questionStart: "Your",
            questionBlank: "_______",
            questionEnd: "should reflect your authentic self, not a manufactured persona.",
            correctAnswer: "Brand",
            incorrectAnswer: "Contract"
        ),
        BrandQuestion(
            questionStart: "Building a personal brand requires",
            questionBlank: "_______",
            questionEnd: "and consistency across all platforms.",
            correctAnswer: "Authenticity",
            incorrectAnswer: "Luck"
        )
    ]
    
    private var currentQuestion: BrandQuestion {
        questions[min(currentQuestionIndex, questions.count - 1)]
    }
    
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
                    Text("Fill in the blank")
                        .font(.custom("Magistral", size: 18))
                        .foregroundColor(.white)
                        .padding(.top, 16)
                    
                    // Question with blank - updated to match designs exactly
                    VStack(spacing: 16) {
                        Text(currentQuestion.questionStart)
                            .font(.custom("Magistral", size: 22))
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                        
                        // Blank line with dashes as in design
                        HStack(spacing: 0) {
                            Spacer()
                            
                            // Show selected answer or dashed line
                            if let selected = selectedAnswer {
                                Text(selected)
                                    .font(.custom("Magistral", size: 22))
                                    .fontWeight(.bold)
                                    .foregroundColor(brandGold)
                            } else {
                                Text("—————")
                                    .font(.custom("Magistral", size: 22))
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                            }
                            
                            Spacer()
                        }
                        .frame(height: 30)
                        
                        Text(currentQuestion.questionEnd)
                            .font(.custom("Magistral", size: 22))
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 60) // More space between question and answers
                    
                    // Answer choices - minimalist design to match mockup
                    VStack(spacing: 30) {
                        ForEach(currentQuestion.options, id: \.self) { option in
                            Button(action: {
                                selectAnswer(option)
                            }) {
                                Text(option)
                                    .font(.custom("Magistral", size: 20))
                                    .fontWeight(.medium)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 12)
                                    .background(
                                        selectedAnswer == option
                                            ? brandBlue
                                            : Color.clear
                                    )
                                    .cornerRadius(8)
                            }
                            .disabled(showingFeedback || showingNextQuestion)
                        }
                    }
                    .padding(.horizontal, 30)
                }
                
                Spacer()
                
                // Next question button (only shows after answering)
                if showingNextQuestion {
                    Button(action: {
                        goToNextQuestion()
                    }) {
                        Text(currentQuestionIndex >= questions.count - 1 ? "Finish" : "Next Question")
                            .font(.custom("Magistral", size: 16))
                            .fontWeight(.medium)
                            .foregroundColor(brandWhite)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(brandBlue)
                            .cornerRadius(8)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                }
                
                // If feedback is showing but next button isn't yet, show points earned
                else if showingFeedback && isCorrect {
                    HStack {
                        Text("+10 POINTS")
                            .font(.custom("Magistral", size: 16))
                            .fontWeight(.bold)
                            .foregroundColor(brandGold)
                    }
                    .padding(.bottom, 20)
                }
            }
            
            // MARK: - End Game Screens Overlay
            if flowCoordinator.currentScreen != .none {
                ZStack {
                    // Full screen black overlay
                    Color.black.edgesIgnoringSafeArea(.all)
                    
                    // Game result screen
                    if flowCoordinator.currentScreen == .results, let result = flowCoordinator.gameResult {
                        GameResultView(
                            score: result.score,
                            speedyAnswers: result.speedyAnswers,
                            livesRemaining: result.livesRemaining,
                            gameType: result.gameType,
                            onContinue: { flowCoordinator.showInvestment() }
                        )
                    }
                    
                    // Investment opportunity screen
                    else if flowCoordinator.currentScreen == .investment, let investment = flowCoordinator.investmentOffer {
                        InvestmentOpportunityView(
                            investment: investment,
                            onDecline: { flowCoordinator.promptDeclineConfirmation() },
                            onInquire: { flowCoordinator.inquireAboutInvestment() },
                            showDeclineConfirmation: $flowCoordinator.showDeclineConfirmation
                        )
                    }
                    
                    // Premium upsell screen
                    else if flowCoordinator.currentScreen == .premium {
                        PremiumUpsellView(
                            onReturnHome: { flowCoordinator.returnHome() },
                            onUnlockPremium: { flowCoordinator.unlockPremium() }
                        )
                    }
                }
                .transition(.opacity)
                .zIndex(100) // Ensure it's on top of everything
            }
        }
        .navigationBarTitle("Brand Builder", displayMode: .inline)
        .navigationBarItems(leading: Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            HStack {
                Image(systemName: "chevron.left")
                Text("Back")
            }
            .foregroundColor(brandGold)
        })
        .onAppear {
            // Start timer for first question when view appears
            answerStartTime = Date()
        }
        // Navigate back to dashboard when flowCoordinator says to return home
        .onChange(of: flowCoordinator.currentScreen) { newScreen in
            if newScreen == .none {
                // This dismisses the current view to go back to the dashboard
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
    
    // Check if the selected answer is correct
    private func selectAnswer(_ option: String) {
        // Only process if no answer is already selected
        guard selectedAnswer == nil else { return }
        
        selectedAnswer = option
        isCorrect = option == currentQuestion.correctAnswer
        
        // Calculate speed bonus if correct (based on response time)
        if isCorrect, let startTime = answerStartTime {
            let timeTaken = Date().timeIntervalSince(startTime)
            
            // Award points and track speedy answers
            points += 10
            
            // Count speedy answers (under 4 seconds)
            if timeTaken < 4.0 {
                speedyAnswersCount += 1
            }
        }
        
        withAnimation {
            showingFeedback = true
        }
        
        // Show next question button after a short delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            withAnimation {
                showingNextQuestion = true
            }
        }
    }
    
    // Move to the next question or finish the game
    private func goToNextQuestion() {
        withAnimation {
            // Reset state for next question
            selectedAnswer = nil
            showingFeedback = false
            showingNextQuestion = false
            
            // Reset timer for next question
            answerStartTime = Date()
            
            // Go to next question or end game
            if currentQuestionIndex < questions.count - 1 {
                currentQuestionIndex += 1
            } else {
                // Game is complete, show the end-game flow
                finishGame()
            }
        }
    }
    
    // Called when the game is complete to show end-game screens
    private func finishGame() {
        // Create game result
        let result = GameResult(
            score: points,
            speedyAnswers: speedyAnswersCount,
            livesRemaining: remainingLives,
            gameType: .brandBuilder
        )
        
        // Trigger game completion in flow coordinator
        flowCoordinator.completeGame(result: result)
    }
}

// MARK: - Preview
struct BrandBuilderGameView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            BrandBuilderGameView()
        }
    }
}
