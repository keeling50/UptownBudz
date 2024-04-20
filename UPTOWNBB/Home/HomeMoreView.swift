//
//  HomeMoreView.swift
//  UPTOWNBB
//
//  Created by Kendall Keeling on 3/24/24.
//

import SwiftUI

struct HomeMoreView: View {
    var body: some View {
        VStack{
            Text("More Products")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.black)
                .frame(maxWidth: .infinity, alignment: .leading )
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading )
        .background(Color.gray.opacity(0.1).ignoresSafeArea())
        
    }
}

struct HomeMoreView_Previews: PreviewProvider {
    static var previews: some View {
        HomeMoreView()
    }
}
