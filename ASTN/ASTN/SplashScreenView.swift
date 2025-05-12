//
//  SplashScreenView.swift
//  ASTN
//
//  Created by Joel Myers on 5/2/25.
//

import SwiftUI
import UIKit

struct SplashScreenView: View {
    @State private var isActive = false
    @State private var opacity = 0.5
    @State private var scale: CGFloat = 0.8
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                
                VStack {
                    Spacer()
                    
                    Image("ASTN_LaunchLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 180, height: 180)
                        .opacity(opacity)
                        .scaleEffect(scale)
                    
//                    Text("ASTN")
//                        .font(.system(size: 42, weight: .bold))
//                        .foregroundColor(.white)
//                        .padding(.top, 20)
//                        .opacity(opacity)
//                        .scaleEffect(scale)
                    
                    Spacer()
                    
                    Text("Version 1.0")
                        .font(.system(size: 16))
                        .foregroundColor(.gray)
                        .padding(.bottom, 20)
                        .opacity(opacity)
                }
            }
            .onAppear {
                // Animate the logo and text appearance
                withAnimation(.easeIn(duration: 1.2)) {
                    self.opacity = 1.0
                    self.scale = 1.0
                }
                
                // Navigate to next screen after a delay
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    // Use AppCoordinator to switch to welcome screen
                    AppCoordinator.shared.switchToWelcomeScreen()
                }
            }
        }
    }
}

struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenView()
    }
}
