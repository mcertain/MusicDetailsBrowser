//
//  MovieDataManager.swift
//  MusicDetailsBrowser
//
//  Created by Matthew Certain on 4/15/19.
//  Copyright © 2019 M. Certain. All rights reserved.
//

import Foundation
import UIKit

let MUSIC_LIST_URL:String = "https://mcertain.github.io/web/MusicDetailsBrowser/music"
let MUSIC_DETAILS_URL:String = "https://mcertain.github.io/web/MusicDetailsBrowser/musicdata"

struct MovieItem : Decodable, Equatable {
    let title: String
    let image: String
    let id: String
    var imageData: Data?
}

struct MovieDetails : Decodable, Equatable {
    let title: String
    let image: String
    let id: String
    let index: Int
}

class MovieDataManager {
    
    // MovieDataManager should be singleton since we only need one instance for
    // helper parsing functions and to store the Movie List Items
    static var singletonInstance:MovieDataManager? = nil
    fileprivate var movieItems: [MovieItem?]?
    
    private init() { }
    
    static func GetInstance() ->MovieDataManager? {
        if(MovieDataManager.singletonInstance == nil) {
            MovieDataManager.singletonInstance = MovieDataManager()
        }
        return MovieDataManager.singletonInstance
    }
    
    func storeMovieData(receivedJSONData: Data?) -> Bool {
        if(receivedJSONData != nil) {
            do {
                movieItems = try JSONDecoder().decode([MovieItem?].self, from: receivedJSONData!)
            }
            catch {
                print("Failed to decode JSON Data")
                return false
            }
        }
        return true
    }
    
    func decodeMovieDetails(receivedJSONData: Data?) -> MovieDetails? {
        var movieDetails: MovieDetails? = nil
        if(receivedJSONData != nil) {
            do {
                movieDetails = try JSONDecoder().decode(MovieDetails.self, from: receivedJSONData!)
            }
            catch {
                print("Failed to decode JSON Data")
            }
        }
        return movieDetails
    }
    
    func getMovieCount() -> Int {
        return movieItems?.count ?? 0
    }
    
    func getMovieTitle(atIndex: Int) -> String? {
        guard movieItems?[atIndex] != nil else {
            return nil
        }
        return movieItems?[atIndex]?.title
    }
    
    func getMovieID(atIndex: Int) -> String? {
        guard movieItems?[atIndex] != nil else {
            return nil
        }
        return movieItems?[atIndex]?.id
    }
    
    func getMovieImageURL(atIndex: Int) -> URL? {
        guard movieItems?[atIndex] != nil else {
            return nil
        }
        return URL(string: (movieItems?[atIndex]?.image)!)
    }
    
    func setMovieCoverImage(atIndex: Int, withData: Data) {
        movieItems?[atIndex]?.imageData = withData
    }
    
    func getMovieCoverImage(atIndex: Int) -> UIImage? {
        guard movieItems?[atIndex]?.imageData != nil else {
            return nil
        }
        return UIImage(data: (movieItems?[atIndex]?.imageData)!)
    }
}
