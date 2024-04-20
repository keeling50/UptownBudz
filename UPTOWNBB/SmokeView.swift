//
//  SmokeView.swift
//  UPTOWNBB
//
//  Created by Kendall Keeling on 4/20/24.
//
import SwiftUI

struct SmokeView: View {
    var body: some View {
        ZStack {  // Use ZStack for overlaying text directly on the image
            // Background image
            Image("DALL·E 2024-04-20 11.40.58")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)  // Ensure the image covers the entire screen

            // Text overlay centered within the view
            VStack {
                Text("Smoke Club Collection")
                    .font(.title)  // Increased font size for better visibility
                    .fontWeight(.bold)  // Make text bold for better legibility
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.black.opacity(0.5))  // Semi-transparent background to enhance readability
                    .cornerRadius(10)
                    .padding()  // Ensure padding around the text block for aesthetics
            }
        }
    }
}

struct SmokeView_Previews: PreviewProvider {
    static var previews: some View {
        SmokeView()
    }
}


