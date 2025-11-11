//
//  MovieDetailView.swift
//  MovieDbLike
//
//  Created by Houssam Dine Abdoul Wahab on 08/11/25.
//

import SwiftUI

struct MovieDetailView: View {
    let movie : Movie
    var body: some View {
        ScrollView {
       
                VStack {
                    AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w500\(movie.posterPath ?? "")")) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 180)
                            .blur(radius: 20)
                    } placeholder: {
                        Color.gray.opacity(0.3)
                            .frame(width:160, height:220)
                            .cornerRadius(10)
                    }
                    HStack {
                        VStack {
                            Text(movie.title)
                                .multilineTextAlignment(.center)
                                .font(.title3)
                                .foregroundStyle(.white)
                                .bold()
                            HStack {
                                Text(FormatDate(from: movie.releaseDate))
                                    .padding(.horizontal)
                                
                                Text(String(format: "%.1f", movie.voteAverage))
                                Image(systemName: "star.fill")
                                    .foregroundStyle(.yellow)
 
                            }.font(.caption)
                            
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .frame(width: 80,height: 30)
                                HStack {
                                    Image(systemName: "play.fill")
                                    Link("Trailer", destination: URL(string: "https://www.youtube.com/watch?v=abc123")!)
                                }  .font(.caption)
                                    .foregroundColor(.blue)
                               
                            }
                        }.padding()
                        
                        Spacer()
                        AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w500\(movie.posterPath ?? "")")) { image in
                            image
                                .resizable()
                                .frame(width:160,height: 220)
                                .cornerRadius(10)
                                .shadow(color:.white,radius: 0.5)
                        } placeholder: {
                            Color.gray.opacity(0.3)
                                .frame(width:160, height:220)
                                .cornerRadius(10)
                        }
                    }.padding(.horizontal)
                    HStack  {
                        Text("Overview")
                            .foregroundStyle(.gray)
                            .bold()
                            .font(.title2)
                        Spacer()
                    }.padding(5)
                    if !movie.overview.isEmpty {
                        Text(movie.overview)
                            .padding(3)
                    } else {
                        Text("Description unvailable")
                            .padding(3)
                    }
                    
                    Spacer()
                }
            }
            
        }
        
    
    func FormatDate(from dateString: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        
        if let date = inputFormatter.date(from: dateString) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "yyyy"
            return outputFormatter.string(from: date)
        } else {
            return "Date Inconnue"
        }
    }
}

