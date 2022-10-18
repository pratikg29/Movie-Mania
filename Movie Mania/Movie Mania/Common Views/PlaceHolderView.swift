//
//  PlaceHolderView.swift
//  Movie Mania
//
//  Created by Pratik on 18/10/22.
//

import SwiftUI

struct PlaceHolderView: View {
    var body: some View {
        RoundedRectangle(cornerRadius: ThemeManager.posterCornerRadius, style: .continuous)
            .fill(LinearGradient(colors: [.init(white: 0.7), .init(white: 0.95)], startPoint: .bottomTrailing, endPoint: .topLeading))
    }
}
