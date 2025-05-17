import SwiftUI

// MARK: - Brand Question Model
struct BrandQuestion: Identifiable {
    let id = UUID()
    let questionStart: String
    let questionBlank: String
    let questionEnd: String
    let correctAnswer: String
    let options: [String]
    
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
            options: ["Brand", "Contract", "Ability", "Network"]
        ),
        BrandQuestion(
            questionStart: "Athletes who consistently",
            questionBlank: "_______",
            questionEnd: "content have stronger social media engagement.",
            correctAnswer: "Create",
            options: ["Create", "Share", "Like", "Delete"]
        ),
        BrandQuestion(
            questionStart: "A strong personal brand can lead to",
            questionBlank: "_______",
            questionEnd: "opportunities beyond your playing career.",
            correctAnswer: "Endorsement",
            options: ["Endorsement", "Coaching", "Trading", "Media"]
        ),
        BrandQuestion(
            questionStart: "Your",
            questionBlank: "_______",
            questionEnd: "should reflect your authentic self, not a manufactured persona.",
            correctAnswer: "Brand",
            options: ["Brand", "Contract", "Interview", "Highlight"]
        ),
        BrandQuestion(
            questionStart: "Building a personal brand requires",
            questionBlank: "_______",
            questionEnd: "and consistency across all platforms.",
            correctAnswer: "Authenticity",
            options: ["Authenticity", "Luck", "Money", "Fame"]
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
                    
                    // Question with blank
                    VStack(spacing: 4) {
                        Text(currentQuestion.questionStart)
                            .font(.custom("Magistral", size: 22))
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                        
                        Text(currentQuestion.questionBlank)
                            .font(.custom("Magistral", size: 22))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.vertical, 8)
                            .frame(width: 120, alignment: .center)
                            .overlay(
                                Rectangle()
                                    .frame(height: 2)
                                    .offset(y: 12)
                                    .foregroundColor(.white)
                            )
                        
                        Text(currentQuestion.questionEnd)
                            .font(.custom("Magistral", size: 22))
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 40)
                    
                    // Answer choices
                    VStack(spacing: 12) {
                        ForEach(currentQuestion.options, id: \.self) { option in
                            Button(action: {
                                selectAnswer(option)
                            }) {
                                Text(option)
                                    .font(.custom("Magistral", size: 18))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.vertical, 16)
                                    .padding(.horizontal, 20)
                                    .background(
                                        selectedAnswer == option
                                            ? (showingFeedback ? (isCorrect ? brandGreen : Color.red) : brandBlue)
                                            : Color.clear
                                    )
                                    .cornerRadius(4)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 4)
                                            .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                                    )
                            }
                            .disabled(showingFeedback || showingNextQuestion)
                        }
                    }
                    .padding(.horizontal, 20)
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
    }
    
    // Check if the selected answer is correct
    private func selectAnswer(_ option: String) {
        selectedAnswer = option
        isCorrect = option == currentQuestion.correctAnswer
        
        withAnimation {
            showingFeedback = true
        }
        
        // Award points for correct answer
        if isCorrect {
            points += 10
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
            
            // Go to next question or end game
            if currentQuestionIndex < questions.count - 1 {
                currentQuestionIndex += 1
            } else {
                // Game is complete, handle completion
                // This could navigate to a results screen or dismiss back to workouts
                presentationMode.wrappedValue.dismiss()
            }
        }
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
