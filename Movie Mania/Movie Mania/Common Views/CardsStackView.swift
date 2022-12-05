//
//  CardsStackView.swift
//  Carousel
//
//  Created by Pratik on 05/12/22.
//

import SwiftUI

enum Category: Int, Identifiable, CaseIterable {
    case nowPlaying, popular, upComming, topRated
    
    var id: Int { rawValue }
    
    var title: String {
        switch self {
        case .popular:
            return "Popular"
        case .nowPlaying:
            return "Now Playing"
        case .upComming:
            return "Upcomming"
        case .topRated:
            return "Top Rated"
        }
    }
    
    var color: Color {
        switch self {
        case .popular:
            return .orange
        case .nowPlaying:
            return .teal
        case .upComming:
            return .pink
        case .topRated:
            return .purple
        }
    }
}

struct TestView: View {
    @State private var isExpanded: Bool = false
    @State private var selectedCategory: Category = .nowPlaying
    @State private var categories: [Category] = Category.allCases
    @Namespace var namespace
    
    var body: some View {
        ZStack {
            Color(white: 0.95)
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation {
                        isExpanded.toggle()
                    }
                }
            CardsStackView(isExpanded: $isExpanded,
                           selection: $selectedCategory,
                           items: $categories) { category in
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(category.color)
                    .aspectRatio(9/11, contentMode: .fit)
                //                .opacity(0.5)
                
            }
            .frame(width: 250)
        }
    }
}

struct CardsStackView<Content: View, T: Identifiable>: View {
    @Binding var isExpanded: Bool
    @Binding var selection: T
    @Binding var items: [T]
    var content: (T) -> Content
    
    var body: some View {
        ZStack {
            ForEach(Array(items.reversed().enumerated()), id: \.element.id) { index, item in
                content(item)
                    .scaleEffect(1 - (CGFloat(items.count - index) * 0.05))
                    .rotation3DEffect(.degrees(isExpanded ? -15 : 0), axis: (1, 0, 0))
                    .offset(y: CGFloat(index) * (isExpanded ? 80 : 20))
                    .shadow(radius: 20)
                    .onTapGesture {
                        guard isExpanded else { return }
                        withAnimation {
                            selection = item
                        }
                    }
            }
            
            
        }
        .gesture(
            DragGesture()
                .onChanged({ value in
                    if value.translation.height < 0 {
                        withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.5, blendDuration: 0.5)) {
                            isExpanded = false
                        }
                    } else if value.translation.height > 0 {
                        withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.5, blendDuration: 0.5)) {
                            isExpanded = true
                        }
                    }
                })
        )
    }
}

struct CardsStackView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
//            .preferredColorScheme(.dark)
    }
}
