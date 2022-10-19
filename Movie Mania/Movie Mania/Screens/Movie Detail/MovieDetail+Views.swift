//
//  MovieDetail+Views.swift
//  Movie Mania
//
//  Created by Pratik on 18/10/22.
//

import SwiftUI

extension MovieDetailScreen {
    struct HeaderView: View {
        let movie: Movie
        var body: some View {
            HStack {
                VStack(alignment: .leading) {
                    Text(movie.title)
                        .font(.system(size: 30, weight: .semibold, design: .rounded))
                        .lineLimit(2)
                    
                    Text(movie.yearText + " " + movie.durationText)
                        .font(.system(size: 16, weight: .regular, design: .rounded))
                }
                Spacer(minLength: 0)
            }
        }
    }
    
    struct PosterDetailView: View {
        let movie: Movie
        @StateObject var backdropLoader = ImageLoader()
        @StateObject var posterLoader = ImageLoader()
        private let posterWidth: CGFloat = 100
        private var posterHeight: CGFloat {
            posterWidth * 16 / 9
        }
        
        var body: some View {
            VStack(alignment: .leading) {
                Group {
                    if backdropLoader.image != nil {
                        Image(uiImage: backdropLoader.image!)
                            .resizable()
                    } else {
                        PlaceHolderView()
                    }
                }
                .aspectRatio(16/9, contentMode: .fit)
                .clipShape(RoundedRectangle(cornerRadius: ThemeManager.posterCornerRadius, style: .continuous))
                
                HStack(alignment: .top, spacing: 20) {
                    Group {
                        if posterLoader.image != nil {
                            Image(uiImage: posterLoader.image!)
                                .resizable()
                        } else {
                            PlaceHolderView()
                        }
                    }
                    .aspectRatio(9/16, contentMode: .fit)
                    .frame(width: posterWidth)
                    .clipShape(RoundedRectangle(cornerRadius: ThemeManager.posterCornerRadius, style: .continuous))
                    
                    VStack(alignment: .leading) {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                movie.genres.map { genres in
                                    ForEach(genres) { genre in
                                        Text(genre.name)
                                            .padding(.horizontal, 10)
                                            .padding(.vertical, 5)
                                            .background(
                                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                                    .stroke()
                                                    .foregroundStyle(.secondary)
                                            )
                                    }
                                }
                            }
                        }
                        
                        Text(movie.overview)
                            .font(.footnote)
                            .lineLimit(6)
                    }
                    .padding(.top, 10)
                }
                .frame(height: posterHeight)
                
                watchListButton
                    .padding(.top, 10)
                
                ratingView
                    .padding(.top, 10)
            }
            .onAppear {
                backdropLoader.loadImage(with: movie.backdropURL)
                posterLoader.loadImage(with: movie.posterURL)
            }
        }
        
        @ViewBuilder private var watchListButton: some View {
            Button {
                
            } label: {
                Label("Add to Watchlist", systemImage: "plus")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .frame(height: 40)
            }
            .buttonStyle(.bordered)
            .tint(.teal)
            .font(.system(size: 20, weight: .medium, design: .rounded))
            .clipShape(RoundedRectangle(cornerRadius: ThemeManager.posterCornerRadius, style: .continuous))
        }
        
        @ViewBuilder private var ratingView: some View {
            HStack {
                VStack {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                    
                    HStack {
                        Text(movie.scoreText)
                            .font(.system(size: 16, weight: .medium, design: .rounded))
                    }
                    Text("\(movie.voteCount)")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                HStack {
                    ForEach(0..<5) { _ in
                        Image(systemName: "star")
                            .font(.title)
                            .foregroundColor(.yellow)
                    }
                }
                .overlay {
                    GeometryReader { geo in
                        HStack {
                            ForEach(0..<5) { _ in
                                Image(systemName: "star.fill")
                                    .font(.title)
                                    .foregroundColor(.yellow)
                            }
                        }
                        .mask {
                            HStack {
                                Rectangle()
                                    .frame(width: geo.size.width * movie.ratingProgress, alignment: .leading)
                                Spacer(minLength: 0)
                            }
                        }
                    }
                }
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 20)
            .background(
                RoundedRectangle(cornerRadius: ThemeManager.posterCornerRadius, style: .continuous)
                    .fill(Color.init(white: 0.95))
            )
        }
    }
    
    struct CraditsView: View {
        let movie: Movie
        var body: some View {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Starring")
                        .font(.system(.headline, design: .rounded))
                    
                    if movie.cast != nil {
                        VStack(alignment: .leading) {
                            ForEach(movie.cast!) { star in
                                Text(star.name)
                            }
                        }
                    } else {
                        Text("Fetching Data")
                            .redacted(reason: .placeholder)
                    }
//                    movie.cast.map { stars in
//                        VStack(alignment: .leading) {
//                            ForEach(stars) { star in
//                                Text(star.name)
//                            }
//                        }
//                    }
                }
                
                Spacer(minLength: 0)
                
                VStack(alignment: .leading, spacing: 20) {
                    if movie.directors != nil {
                        VStack(alignment: .leading, spacing: 10) {
                            Text(movie.directors!.count > 1 ? "Directors" : "Director")
                                .font(.system(.headline, design: .rounded))
                            
                            VStack(alignment: .leading) {
                                ForEach(movie.directors!) { director in
                                    Text(director.name)
                                }
                            }
                        }
                    }
                    
                    if movie.producers != nil {
                        VStack(alignment: .leading, spacing: 10) {
                            Text(movie.producers!.count > 1 ? "Producers" : "Producer")
                                .font(.system(.headline, design: .rounded))
                            
                            VStack(alignment: .leading) {
                                ForEach(movie.producers!) { producer in
                                    Text(producer.name)
                                }
                            }
                        }
                    }
                    
                    if movie.screenWriters != nil {
                        VStack(alignment: .leading, spacing: 10) {
                            Text(movie.screenWriters!.count > 1 ? "Screen Writers" : "Screen Writer")
                                .font(.system(.headline, design: .rounded))
                            
                            VStack(alignment: .leading) {
                                ForEach(movie.screenWriters!) { writer in
                                    Text(writer.name)
                                }
                            }
                        }
                    }
                }
            }
            .padding(.top, 10)
        }
    }
}

struct My_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            MovieDetailScreen.PosterDetailView(movie: Movie.stubbedMovie)
            MovieDetailScreen.CraditsView(movie: Movie.stubbedMovie)
        }
        .padding(.horizontal)
    }
}
