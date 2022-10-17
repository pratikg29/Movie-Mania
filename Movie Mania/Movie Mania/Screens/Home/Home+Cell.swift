//
//  Home+Cell.swift
//  Movie Mania
//
//  Created by Pratik on 17/10/22.
//

import SwiftUI

struct MoviePosterCell: View {
    var movie: Movie
    @StateObject var imageLoader = ImageLoader()
    
    var body: some View {
        ZStack {
            if self.imageLoader.image != nil {
                Image(uiImage: self.imageLoader.image!)
                    .resizable()
            } else {
                PosterPlaceHolderCell(movie: movie)
            }
            
//            VStack {
//                HStack {
//                    Button {
//                        
//                    } label: {
//                        Image("")
//                    }
//                    
//                    Spacer()
//                }
//                
//                Spacer()
//                
//                bottomView
//                    .frame(height: 50)
//                    .frame(maxWidth: .infinity, alignment: .leading)
//                    .padding(.horizontal)
//                    .background(.regularMaterial)
//            }
        }
        .aspectRatio(9/16, contentMode: .fit)
        .clipShape(RoundedRectangle(cornerRadius: ThemeManager.posterCornerRadius, style: .continuous))
        .onAppear {
            self.imageLoader.loadImage(with: movie.posterURL)
        }
    }
    
    @ViewBuilder private var bottomView: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: "star.fill")
//                    .foregroundColor(.yellow)
                    .foregroundStyle(.secondary)
                    .font(.callout)
                
                Text(String(format: "%.1f", movie.voteAverage))
                    .foregroundColor(.secondary)
            }
            
            Text(movie.title)
                .font(.system(size: 20, weight: .medium, design: .rounded))
        }
        .padding(.vertical, 20)
    }
}

struct PosterPlaceHolderCell: View {
    let movie: Movie
    
    var body: some View {
        RoundedRectangle(cornerRadius: ThemeManager.posterCornerRadius, style: .continuous)
            .fill(LinearGradient(colors: [.init(white: 0.7), .init(white: 0.95)], startPoint: .bottomTrailing, endPoint: .topLeading))
            .overlay {
                VStack(spacing: 20) {
                    ProgressView()
                    
                    Text(movie.title)
                        .font(.system(size: 20, weight: .medium, design: .rounded))
                }
                .padding()
            }
    }
}


struct MovieCell_Previews: PreviewProvider {
    static var previews: some View {
        MoviePosterCell(movie: Movie.stubbedMovie)
            .padding()
    }
}
