//
//  CarouselView.swift
//  Carousel
//
//  Created by Pratik on 04/12/22.
//

import SwiftUI

struct CarouselView<Content: View, T: Identifiable>: View {
    var content: (T, Int) -> Content
    var list: [T]
    
    var spacing: CGFloat
    var trailingSpace: CGFloat
    @Binding var index: Int
    
    @GestureState var offset: CGFloat = 0
    @State private var currentIndex: Int = 0
    
    init(spacing: CGFloat = 30, trailingSpace: CGFloat = 100, index: Binding<Int>, items: [T], @ViewBuilder content: @escaping (T, Int)->Content) {
        self.list = items
        self.spacing = spacing
        self.trailingSpace = trailingSpace
        self._index = index
        self.content = content
    }
    
    var body: some View {
        GeometryReader { bounds in
            
            let width = bounds.size.width - (trailingSpace - spacing)
            let adjustmentWidth = (trailingSpace / 2) - spacing
            
            HStack(spacing: spacing) {
                ForEach(Array(list.enumerated()), id: \.element.id) { index, item in
                    GeometryReader { geo in
                        content(item, index)
                            .rotationEffect(.degrees( offsetFactor(cardMidX: geo.frame(in: .global).midX, screenWidth: bounds.size.width) * 3 ))
                            .offset(y: abs(offsetFactor(cardMidX: geo.frame(in: .global).midX, screenWidth: bounds.size.width)) * 50)
                    }
                    .frame(width: bounds.size.width - trailingSpace)
                }
                
            }
            .padding(.horizontal, spacing)
            .offset(x: (CGFloat(currentIndex) * -width) + adjustmentWidth + offset)
            .gesture(
                DragGesture()
                    .updating($offset, body: { value, out, _ in
                        out = value.translation.width
                    })
                    .onEnded({ value in
                        let offsetX = value.translation.width
                        
                        // value between 0...1
                        let progress = -offsetX / width
                        
                        // value will be 0 or 1
                        let roundIndex = progress.rounded()
                        
                        currentIndex = max(min(currentIndex + Int(roundIndex), list.count - 1), 0)
                        currentIndex = index
                    })
                    .onChanged({ value in
                        let offsetX = value.translation.width
                        
                        // value between 0...1
                        let progress = -offsetX / width
                        
                        // value will be 0 or 1
                        let roundIndex = progress.rounded()
                        
                        index = max(min(currentIndex + Int(roundIndex), list.count - 1), 0)
                    })
            )
        }
        .animation(.easeInOut, value: offset == 0)
    }
    
    private func offsetFactor(cardMidX:CGFloat, screenWidth: CGFloat) -> CGFloat {
        (cardMidX - (screenWidth/2)) / (screenWidth/2)
    }
}
