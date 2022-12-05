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
    @State private var currentIndex: Int = 0
    @State private var selectedImage: UIImage = UIImage(named: "placeholderPoster")!
    @State private var fadeOut = false
    
    var body: some View {
        GeometryReader { bounds in
            ZStack(alignment: .bottom) {
                Image(uiImage: selectedImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: bounds.size.width, height: bounds.size.height, alignment: .center)
                    .opacity(fadeOut ? 0 : 1)
                    .animation(.easeInOut(duration: 0.3), value: fadeOut)
                    .overlay(.regularMaterial)
                
                if viewModel.movies != nil {
                    CarouselView(spacing: 50, trailingSpace: 150, index: $currentIndex, items: viewModel.movies!) { movie, index in
                        MoviePosterCell(movie: movie)
                    }
                    .frame(height: 430)
                    .padding(.bottom, 50)
                } else {
                    RoundedRectangle(cornerRadius: ThemeManager.posterCornerRadius, style: .continuous)
                        .fill(LinearGradient(colors: [.init(white: 0.7), .init(white: 0.95)], startPoint: .bottomTrailing, endPoint: .topLeading))
                        .frame(maxWidth: .infinity)
                }
            }
            .onAppear {
                viewModel.loadMovies(with: type)
            }
            .onChange(of: currentIndex) { newValue in
                guard viewModel.images.indices.contains(newValue) else { return }
                self.fadeOut.toggle()                 // 1) fade out
                
                // delayed appear
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    withAnimation {
                        selectedImage = viewModel.images[newValue]    // 2) change image
                        self.fadeOut.toggle()         // 3) fade in
                    }
                }
            }
            .onChange(of: viewModel.images) { newValue in
                guard viewModel.images.isEmpty else { return }
                withAnimation(.easeInOut) {
                    selectedImage = viewModel.images[currentIndex]
                }
            }
        }
        .ignoresSafeArea()
    }
}

class CarouselModel: ObservableObject {
    @Published var movies: [Movie]?
    @Published var isLoading: Bool = false
    @Published var error: NSError?
    
    private let imageCache = NSCache<AnyObject, AnyObject>()
    @Published var images:[UIImage] = []
    
    private let movieService: MovieService
    
    private let operationQueue = OperationQueue()
    
    init(movieService: MovieService = MovieStore.shared) {
        self.movieService = movieService
        self.operationQueue.maxConcurrentOperationCount = 1
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
                self.loadImages()
            case .failure(let error):
                self.error = error as NSError
            }
        }
    }
    
    func loadImages() {
        guard let movies = movies else { return }
        
        for movie in movies {
            let url = movie.posterURL
            let urlString = url.absoluteString
            
            if let imageFromCache = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
                self.images.append(imageFromCache)
                continue
            }
            
            let downloadOperation = imageDownloadOperation(for: url)
            operationQueue.addOperation(downloadOperation)
        }
    }
    
    func imageDownloadOperation(for url: URL) -> BlockOperation {
        let urlString = url.absoluteString
        return BlockOperation { [weak self] in
            guard let self = self else { return }
            do {
                let data = try Data(contentsOf: url)
                guard let image = UIImage(data: data) else {
                    return
                }
                self.imageCache.setObject(image, forKey: urlString as AnyObject)
                DispatchQueue.main.async { [weak self] in
                    self?.images.append(image)
                    print("Downloaded = \(urlString)")
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

struct PosterCarouselView_Previews: PreviewProvider {
    static var previews: some View {
        PosterCarouselView(type: .upcoming)
    }
}
