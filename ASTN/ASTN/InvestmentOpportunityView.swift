import SwiftUI

struct InvestmentOpportunityView: View {
    let investment: InvestmentOpportunity
    let onDecline: () -> Void
    let onInquire: () -> Void
    @State private var showAdvisorToggle: Bool = false
    @Binding var showDeclineConfirmation: Bool
    
    // Environment to hide the navigation bar back button
    @Environment(\.presentationMode) var presentationMode
    
    // Brand colors
    private let brandBlue = Color.fromHex("#1A2196")
    private let brandGold = Color.fromHex("#E8D5B5")
    
    var body: some View {
        ZStack {
            // Black background
            Color.black.edgesIgnoringSafeArea(.all)
            
            // Main content
            VStack(spacing: 0) {
                // Restaurant/Business logo
                Image(investment.imageAsset)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity)
                    .frame(height: 200)
                    .cornerRadius(10)
                    .padding(.horizontal)
                
                // Investment label
                Text("Investment Opportunity • Limited Time")
                    .font(.custom("Magistral", size: 14))
                    .foregroundColor(.gray)
                    .padding(.top, 10)
                
                // Investment title
                Text(investment.title)
                    .font(.custom("Magistral", size: 30))
                    .foregroundColor(.white)
                    .padding(.top, 5)
                
                // Investment subtitle
                Text(investment.subtitle)
                    .font(.custom("Magistral", size: 18))
                    .foregroundColor(.gray)
                    .padding(.top, 2)
                
                // Rating
                HStack(spacing: 2) {
                    ForEach(1...5, id: \.self) { index in
                        Image(systemName: index <= Int(investment.rating) ? "star.fill" : "star")
                            .foregroundColor(brandGold)
                    }
                    
                    Text("(\(investment.investorCount) Investors)")
                        .font(.custom("Magistral", size: 14))
                        .foregroundColor(.gray)
                        .padding(.leading, 5)
                }
                .padding(.top, 10)
                
                // Divider
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 1)
                    .padding(.vertical, 15)
                    .padding(.horizontal, 20)
                
                // Deal details
                VStack(alignment: .leading, spacing: 15) {
                    Text("Deal Details")
                        .font(.custom("Magistral", size: 18))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text(investment.description)
                        .font(.system(size: 16))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.leading)
                        .padding(.bottom, 10)
                    
                    // Expandable sections
                    ExpandableSection(title: "Growth Projections")
                    
                    ExpandableSection(title: "Share Valuation")
                    
                    // Share with advisor toggle
                    HStack {
                        Text("Share with Advisor")
                            .font(.custom("Magistral", size: 16))
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Toggle("", isOn: $showAdvisorToggle)
                            .labelsHidden()
                            .toggleStyle(SwitchToggleStyle(tint: brandBlue))
                    }
                    .padding(.vertical, 10)
                }
                .padding(.horizontal, 20)
                
                Spacer()
                
                // Action buttons
                HStack(spacing: 10) {
                    // Decline button
                    Button(action: {
                        onDecline()
                    }) {
                        HStack {
                            Image(systemName: "xmark")
                                .font(.system(size: 16, weight: .semibold))
                            
                            Text("Decline")
                                .font(.custom("Magistral", size: 16))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 55)
                        .background(
                            RoundedRectangle(cornerRadius: 27.5)
                                .stroke(Color.white, lineWidth: 1)
                        )
                    }
                    
                    // Inquire button
                    Button(action: {
                        onInquire()
                    }) {
                        HStack {
                            Image(systemName: "checkmark")
                                .font(.system(size: 16, weight: .semibold))
                            
                            Text("Inquire")
                                .font(.custom("Magistral", size: 16))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 55)
                        .background(
                            RoundedRectangle(cornerRadius: 27.5)
                                .fill(brandBlue)
                        )
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 30)
            }
        }
        .alert(isPresented: $showDeclineConfirmation) {
            Alert(
                title: Text("Are you sure?"),
                message: Text("This opportunity may not be available again. Are you sure you want to decline?"),
                primaryButton: .cancel(Text("No, go back")),
                secondaryButton: .destructive(Text("Yes, decline"), action: onDecline)
            )
        }
        // Hide the navigation bar back button
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
}

// Expandable section component
struct ExpandableSection: View {
    let title: String
    @State private var isExpanded: Bool = false
    
    var body: some View {
        VStack {
            HStack {
                Text(title)
                    .font(.custom("Magistral", size: 16))
                    .foregroundColor(.white)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.white)
                    .rotationEffect(.degrees(isExpanded ? 90 : 0))
            }
            .contentShape(Rectangle())
            .onTapGesture {
                withAnimation {
                    isExpanded.toggle()
                }
            }
            
            if isExpanded {
                Text("Details would appear here in the full implementation.")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                    .padding(.top, 5)
            }
        }
        .padding(.vertical, 10)
    }
}

struct InvestmentOpportunityView_Previews: PreviewProvider {
    static var previews: some View {
        InvestmentOpportunityView(
            investment: InvestmentOpportunity.johnnysExample,
            onDecline: {},
            onInquire: {},
            showDeclineConfirmation: .constant(false)
        )
    }
}
