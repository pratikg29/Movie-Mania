//
//  Home+Carousel.swift
//  Movie Mania
//
//  Created by Pratik on 17/10/22.
//

import SwiftUI

struct PosterCarouselView: View {
    let type: MovieListEndpoint
    @StateObject private var viewModel = CarouselModel()
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(type.titleString)
                .font(.system(size: 30, weight: .semibold, design: .rounded))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    if viewModel.movies != nil {
                        ForEach(viewModel.movies!) { movie in
                            MoviePosterCell(movie: movie)
                        }
                    } else {
                        RoundedRectangle(cornerRadius: ThemeManager.posterCornerRadius, style: .continuous)
                            .fill(LinearGradient(colors: [.init(white: 0.7), .init(white: 0.95)], startPoint: .bottomTrailing, endPoint: .topLeading))
                            .frame(maxWidth: .infinity)
                    }
                }
                .padding(.horizontal)
            }
        }
        .onAppear {
            viewModel.loadMovies(with: type)
        }
    }
}

class CarouselModel: ObservableObject {
    @Published var movies: [Movie]?
    @Published var isLoading: Bool = false
    @Published var error: NSError?
    
    private let movieService: MovieService
    
    init(movieService: MovieService = MovieStore.shared) {
        self.movieService = movieService
    }
    
    func loadMovies(with endpoint: MovieListEndpoint) {
        self.movies = nil
        self.isLoading = true
        self.movieService.fetchMovies(from: endpoint) { [weak self] (result) in
            guard let self = self else { return }
            self.isLoading = false
            switch result {
            case .success(let response):
                self.movies = response.results
                
            case .failure(let error):
                self.error = error as NSError
            }
        }
    }
}
