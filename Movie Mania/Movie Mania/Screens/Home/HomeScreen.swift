//
//  HomeScreen.swift
//  Movie Mania
//
//  Created by Pratik on 17/10/22.
//

import SwiftUI

struct HomeScreen: View {
    var body: some View {
        PosterCarouselView(type: .upcoming)
    }
}

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen()
    }
}
