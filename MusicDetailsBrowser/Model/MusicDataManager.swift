//
//  MusicDataManager.swift
//  MusicDetailsBrowser
//
//  Created by Matthew Certain on 4/15/19.
//  Copyright © 2019 M. Certain. All rights reserved.
//

import Foundation
import UIKit

let MUSIC_LIST_URL:String = "https://mcertain.github.io/web/MusicDetailsBrowser/music"
let MUSIC_DETAILS_URL:String = "https://mcertain.github.io/web/MusicDetailsBrowser/musicdata"

let COVER_ART_PREFIX:String = "https://coverartarchive.org/release/"
let COVER_ART_FULL_SUFFIX:String = "/front"
let COVER_ART_THUMB_SUFFIX:String = "-250"

let SPOTIFY_URL_PREFIX:String = "http://open.spotify.com/track/"
let APPLEMUSIC_URL_PREFIX:String = "https://geo.itunes.apple.com/us/album/"

struct MusicItem : Decodable, Equatable {
    let id: String
    let albumID: String
    let artistName: String
    let albumTitle: String
    let songTitle: String
    let image: String
    var imageData: Data?
}

struct MusicDetails : Decodable, Equatable {
    let index: Int
    let id: String
    let albumID: String
    let artistName: String
    let albumTitle: String
    let songTitle: String
    let image: String
    let length: String
    let spotifyTrackID: String
    let AppleMusicID: String
}

class MusicDataManager {
    
    // MusicDataManager should be singleton since we only need one instance for
    // helper parsing functions and to store the Music List Items
    static var singletonInstance:MusicDataManager? = nil
    fileprivate var musicItems: [MusicItem?]?
    
    private init() { }
    
    static func GetInstance() ->MusicDataManager? {
        if(MusicDataManager.singletonInstance == nil) {
            MusicDataManager.singletonInstance = MusicDataManager()
        }
        return MusicDataManager.singletonInstance
    }
    
    func storeMusicData(receivedJSONData: Data?) -> Bool {
        if(receivedJSONData != nil) {
            do {
                musicItems = try JSONDecoder().decode([MusicItem?].self, from: receivedJSONData!)
            }
            catch {
                print("Failed to decode JSON Data")
                return false
            }
        }
        return true
    }
    
    func decodeMusicDetails(receivedJSONData: Data?) -> MusicDetails? {
        var musicDetails: MusicDetails? = nil
        if(receivedJSONData != nil) {
            do {
                musicDetails = try JSONDecoder().decode(MusicDetails.self, from: receivedJSONData!)
            }
            catch {
                print("Failed to decode JSON Data")
            }
        }
        return musicDetails
    }
    
    func getMusicCount() -> Int {
        return musicItems?.count ?? 0
    }
    
    func getSongTitle(atIndex: Int) -> String? {
        guard musicItems?[atIndex] != nil else {
            return nil
        }
        return musicItems?[atIndex]?.songTitle
    }
    
    func getAlbumTitle(atIndex: Int) -> String? {
        guard musicItems?[atIndex] != nil else {
            return nil
        }
        return musicItems?[atIndex]?.albumTitle
    }
    
    func getMusicID(atIndex: Int) -> String? {
        guard musicItems?[atIndex] != nil else {
            return nil
        }
        return musicItems?[atIndex]?.id
    }
    
    func getMusicImageURL(atIndex: Int) -> URL? {
        guard musicItems?[atIndex] != nil else {
            return nil
        }
        //return URL(string: (musicItems?[atIndex]?.image)!)
        return URL(string: COVER_ART_PREFIX + (musicItems?[atIndex]?.image)! + COVER_ART_FULL_SUFFIX)
    }
    
    func getCoverImageThumbURL(atIndex: Int) -> URL? {
        guard musicItems?[atIndex] != nil else {
            return nil
        }
        return URL(string: COVER_ART_PREFIX + (musicItems?[atIndex]?.image)! + "/" + (musicItems?[atIndex]?.albumID)! + COVER_ART_THUMB_SUFFIX)
    }
    
    func setMusicCoverImage(atIndex: Int, withData: Data) {
        musicItems?[atIndex]?.imageData = withData
    }
    
    func getMusicCoverImage(atIndex: Int) -> UIImage? {
        guard musicItems?[atIndex]?.imageData != nil else {
            return nil
        }
        return UIImage(data: (musicItems?[atIndex]?.imageData)!)
    }
}
