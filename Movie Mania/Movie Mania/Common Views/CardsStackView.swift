//
//  CardsStackView.swift
//  Carousel
//
//  Created by Pratik on 05/12/22.
//

import SwiftUI

enum Category: Int, Identifiable, CaseIterable, Equatable {
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
    @State private var selectedCategory: Category? = nil
    @State private var categories: [Category] = Category.allCases
    
    var body: some View {
        ZStack {
            CardsStackView(isExpanded: $isExpanded,
                           selection: $selectedCategory,
                           items: $categories) { category in
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(category.color)
                    .aspectRatio(9/11, contentMode: .fit)
            }
            .frame(width: 250)
        }
    }
}

struct CardsStackView<Content: View, T: Identifiable & Equatable>: View {
    @Binding var isExpanded: Bool
    @Binding var selection: T?
    @Binding var items: [T]
    var content: (T) -> Content
    
    var body: some View {
        ZStack {
            ForEach(Array(items.reversed().enumerated()), id: \.element.id) { index, item in
                content(item)
                    .scaleEffect(getScale(for: index, item: item))
                    .rotation3DEffect(.degrees(isExpanded ? -15 : 0), axis: (1, 0, 0))
                    .offset(y: getOffset(for: index, item: item))
                    .shadow(radius: 20)
                    .onTapGesture {
                        guard isExpanded else { return }
                        withAnimation(.easeInOut) {
                            if selection != item {
                                selection = item
                            } else {
                                selection = nil
                            }
                        }
                    }
            }
        }
        .gesture(
            DragGesture()
                .onChanged({ value in
                    guard selection == nil else { return }
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
    
    private func getOffset(for index: Int, item: T) -> CGFloat {
        if (selection != nil) {
            if (selection == item) {
                return CGFloat(index) * (isExpanded ? 80 : 20) - 100
            } else {
                return CGFloat(index) * (isExpanded ? 80 : 20)
            }
        } else {
            return CGFloat(index) * (isExpanded ? 80 : 20)
        }
    }
    
    private func getScale(for index: Int, item: T) -> CGFloat {
        if (selection != nil) {
            if (selection == item) {
                return 1 - (CGFloat(items.count - index) * 0.05) + 0.1
            } else {
                return 1 - (CGFloat(items.count - index) * 0.05)
            }
        } else {
            return 1 - (CGFloat(items.count - index) * 0.05)
        }
    }
}

struct CardsStackView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
//            .preferredColorScheme(.dark)
    }
}
