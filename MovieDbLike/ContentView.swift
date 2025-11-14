//
//  ContentView.swift
//  MovieDbLike
//
//  Created by Houssam Dine Abdoul Wahab on 07/11/25.
//

import SwiftUI

struct ContentView: View {
    @State var languages = "en-US"
    @Namespace var namespace
    
    @State var movies: [Movie] = []
    let columns = [
           GridItem(.flexible()),
           GridItem(.flexible())
       ]
    @State private var searchMovie = ""
   
    
    var filteredMovies: [Movie] {
          if searchMovie.isEmpty {
              return Array(movies.prefix(20))
          } else {
              return movies.filter {
                  $0.title.lowercased().contains(searchMovie.lowercased())
              }
          }
      }
    
    var changeLanguagePlaceholder: String {
        switch languages {
        case "fr-FR": 
            return "Rechercher un Film"
        case "en-US": 
            return "Search for a movie"
        case "it-IT":
            return "Cerca un film"
        case "fa-IR":
             return "جستجو برای فیلم"
        default:
            return "Search for a movie"
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(colors: [.purple,.black,.black], startPoint: .topLeading, endPoint: .bottom).ignoresSafeArea()
              
                ScrollView {
                    LazyVGrid(columns: columns) {
                        ForEach(filteredMovies) { movie in
                            NavigationLink {
                                MovieDetailView(languages: $languages, movie: movie)
                                    .navigationTransition(.zoom(sourceID: "Zoom", in: self.namespace))
                            } label: {
                                VStack {
                                    AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w342\(movie.posterPath ?? "")")) { image in
                                        image
                                            .resizable()
                                            .frame(width:160,height: 220)
                                            .cornerRadius(10)
                                    } placeholder: {
                                            Color.gray.opacity(0.3)
                                                .frame(width:160, height:220)
                                                .cornerRadius(10)
                                    }
                                    Text(movie.title)
                                        .foregroundStyle(.white)
                                        .padding()
                                }
                            }

                        }
                    }.padding(.top,50)
                       
                }
            }
            .navigationTitle("Popular Movie")
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $searchMovie,placement: .navigationBarDrawer(displayMode: .automatic), prompt: changeLanguagePlaceholder)
            .toolbar {
                ToolbarItem {
                    Picker("Languages", selection: $languages) {
                        Text("🇫🇷").tag("fr-FR")
                        Text("🇬🇧").tag("en-US")
                        Text("🇮🇹").tag("it-IT")
                        Text("🇮🇷").tag("fa-IR")
                    }.pickerStyle(.menu)
                        .frame(width: 30)
                }
            }
        }
        .task(id: languages) {
            do {
                movies = try await performAPICall(language: languages)
            } catch {
                print("Error:", error)
            }
        }
    }
}

#Preview {
    ContentView()
}
