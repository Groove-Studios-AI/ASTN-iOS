import SwiftUI

struct OwnershipView: View {
    @Binding var isExpanded: Bool
    let options: [OwnershipOption]
    let onOptionSelected: (OwnershipOption) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header with expand/collapse button
            Button(action: {
                withAnimation {
                    isExpanded.toggle()
                }
            }) {
                HStack {
                    Text("Ownership Opportunities")
                        .font(.custom("Magistral", size: 20).bold())
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(.white.opacity(0.7))
                        .font(.system(size: 16))
                }
            }
            
            // Expanded content
            if isExpanded {
                VStack(spacing: 12) {
                    ForEach(options) { option in
                        OwnershipOptionRow(option: option) {
                            onOptionSelected(option)
                        }
                    }
                }
                .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .padding(20)
        .background(Color.fromHex("#121212"))
        .cornerRadius(16)
    }
}

struct OwnershipOptionRow: View {
    let option: OwnershipOption
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                // Icon
                ZStack {
                    Circle()
                        .fill(Color.fromHex("#1E2787").opacity(0.3))
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: option.iconName)
                        .foregroundColor(.white)
                        .font(.system(size: 16))
                }
                
                // Title and description
                VStack(alignment: .leading, spacing: 4) {
                    Text(option.title)
                        .font(.custom("Magistral", size: 16).bold())
                        .foregroundColor(.white)
                    
                    Text(option.description)
                        .font(.custom("Magistral", size: 12))
                        .foregroundColor(.white.opacity(0.7))
                }
                
                Spacer()
                
                // Chevron
                Image(systemName: "chevron.right")
                    .foregroundColor(.white.opacity(0.7))
                    .font(.system(size: 14))
            }
            .padding(12)
            .background(Color.gray.opacity(0.2))
            .cornerRadius(8)
        }
    }
}
