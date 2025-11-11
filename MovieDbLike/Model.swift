//
//  Model.swift
//  MovieDbLike
//
//  Created by Houssam Dine Abdoul Wahab on 07/11/25.
//

import Foundation
import SwiftUI



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

    for page in 1...200 {
        let urlString = "https://api.themoviedb.org/3/movie/popular?api_key=\(APIKey)&language=\(language)&page=\(page)"
        guard let url = URL(string: urlString) else { continue }

        let (data, _) = try await URLSession.shared.data(from: url)

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        let decoded = try decoder.decode(MoviesResponse.self, from: data)
        allMovies.append(contentsOf: decoded.results)
    }
    
    return allMovies
}

