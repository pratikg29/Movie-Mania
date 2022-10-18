//
//  MovieDetailScreen.swift
//  Movie Mania
//
//  Created by Pratik on 18/10/22.
//

import SwiftUI

struct MovieDetailScreen: View {
    let movieId: Int
    @StateObject private var detailViewModel = MovieDetailState()
    
    var body: some View {
        VStack {
            if detailViewModel.movie != nil {
                HeaderView(movie: detailViewModel.movie!)
                PosterDetailView(movie: detailViewModel.movie!)
                
                Spacer()
            } else {
                Text("Data fetching...")
            }
        }
        .padding(.horizontal)
        .onAppear {
            detailViewModel.loadMovie(id: movieId)
            
        }
    }
}

struct MovieDetailScreen_Previews: PreviewProvider {
    static var previews: some View {
        MovieDetailScreen(movieId: Movie.stubbedMovie.id)
    }
}
