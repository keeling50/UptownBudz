//
//  StaggeredGrid.swift
//  StaggeredGrid
//
//  Created by Ganesh on 14/05/23.
//

import SwiftUI

struct StaggeredGrid<Content: View,T:Identifiable>: View where T: Hashable{
    
    // MARK: - Properties
    var content: (T) -> Content
    var list: [T]
    var columns: Int
    var showIndicators:Bool
    var spacing: CGFloat
    
    init(list: [T], columns: Int, showIndicators: Bool = false, spacing: CGFloat = 10,@ViewBuilder content: @escaping (T) -> Content) {
        self.content = content
        self.list = list
        self.columns = columns
        self.showIndicators = showIndicators
        self.spacing = spacing
    }
    
    func setUpList() -> [[T]]{
        var gridArray: [[T]] = Array(repeating: [], count: columns)
        var currentIndex:Int = 0
        for object in list{
            gridArray[currentIndex].append(object)
            if currentIndex == (columns - 1){
                currentIndex = 0
            }else{
                currentIndex += 1
            }
        }
        return gridArray
    }
    
    
    // MARK: - Body
    var body: some View {
        HStack(alignment: .top, spacing: 20) {
            ForEach(setUpList(),id: \.self){ columnData in
                LazyVStack(spacing: spacing) {
                    ForEach(columnData){ object  in
                        content(object)
                    }
                }
                .padding(.top,GetIndex(values: columnData) == 1 ? 80 : 0)
            }
        }
    }
    func GetIndex(values: [T])->Int{
        let index = setUpList().firstIndex { t in
            return t == values
        } ?? 0
        return index
    }
}
