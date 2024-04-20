//
//  ImageSwiperView.swift
//  UPTOWNBB
//
//  Created by Kendall Keeling on 3/21/24.
//

import SwiftUI


struct ImageSwiperView: View {
    let imageNames: [String] // Your images names or paths

    var body: some View {
        TabView {
            ForEach(imageNames, id: \.self) { imageName in
                Image(imageName)
                    .resizable()
                    .scaledToFill()
                    .clipped()
            }
        }
        .frame(height: 400) // Set your desired frame
        .tabViewStyle(PageTabViewStyle())
        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
        .background(Color.primary.opacity(0.1)) // Adjust color and opacity as needed
        .cornerRadius(5)
        //.edgesIgnoringSafeArea(.top)
        //.edgesIgnoringSafeArea(.bottom)
    }
}

struct ImageSwiperView_Previews: PreviewProvider {
    static var previews: some View {
        let imageNames = ["IMG_1111", "IMG_1111", "IMG_1111"]
        ImageSwiperView(imageNames: imageNames)
    }
}
