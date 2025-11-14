//
//  Model.swift
//  MovieDbLike
//
//  Created by Houssam Dine Abdoul Wahab on 07/11/25.
//

import Foundation
import SwiftUI


//For show movies

struct Movie: Codable, Identifiable {
    let id: Int
    let title: String
    let voteAverage: Double
    let posterPath: String?
    let releaseDate: String
    let overview: String
}

struct MoviesResponse: Codable {
    let results: [Movie]
}


func performAPICall(language: String) async throws -> [Movie] {
    var allMovies: [Movie] = []
    let decoder = JSONDecoder()
    let maxPages = 100

    for page in 1..<maxPages {
        let url = URL(string: "https://api.themoviedb.org/3/movie/popular?api_key=\(APIKey)&language=\(language)&page=\(page)")
        
        let (data, _) = try await URLSession.shared.data(from: url!)

        decoder.keyDecodingStrategy = .convertFromSnakeCase

        let decoded = try decoder.decode(MoviesResponse.self, from: data)
        allMovies.append(contentsOf: decoded.results) 
    }
    
    return allMovies
}



//For show Trailers

struct MovieVideo: Codable, Identifiable {
    let id: String
    let key: String
    let name: String
    let site: String
    let type: String
    let official: Bool?
    let publishedAt: String?
}

struct VideosResponse: Codable {
    let results: [MovieVideo]
}


func fetchTrailerKey(for movieId: Int, language:String) async throws -> String? {
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase

     let url = URL(string: "https://api.themoviedb.org/3/movie/\(movieId)/videos?api_key=\(APIKey)&language=\(language)")
        let (data, _) = try await URLSession.shared.data(from: url!)
        
        let videos = try decoder.decode(VideosResponse.self, from: data).results
        
    let trailer = videos.first {
        $0.site == "YouTube" && $0.type == "Trailer"
    }
        return trailer?.key

}
