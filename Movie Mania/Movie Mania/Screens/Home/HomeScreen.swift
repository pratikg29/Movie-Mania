//
//  HomeScreen.swift
//  Movie Mania
//
//  Created by Pratik on 17/10/22.
//

import SwiftUI

struct HomeScreen: View {
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 35) {
                ForEach(MovieListEndpoint.allCases) { type in
                    PosterCarouselView(type: type)
                        .frame(height: 300)
                }
            }
        }
    }
}

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen()
    }
}
