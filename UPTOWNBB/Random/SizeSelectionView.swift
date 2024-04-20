//
//  SizeSelectionView.swift
//  UPTOWNBB
//
//  Created by Kendall Keeling on 3/21/24.
//

import SwiftUI

struct SizeSelectionView: View {
    let availableSizes: [String]
    @Binding var selectedSize: String
    
    var body: some View {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(availableSizes, id: \.self) { size in
                        Button(action: {
                            self.selectedSize = size
                        }) {
                            Text(size)
                                .padding()
                                .foregroundColor(self.selectedSize == size ? .white : .black)
                                .background(self.selectedSize == size ? Color.blue : Color.clear)
                                .cornerRadius(10)
                        }
                    }
                }
            }
        }
}

