//
//  MusicDetailsController.swift
//  MusicDetailsBrowser
//
//  Created by Matthew Certain on 4/16/19.
//  Copyright © 2019 M. Certain. All rights reserved.
//

import Foundation
import UIKit

class MusicDetailsController : UIViewController, UINavigationControllerDelegate {
    
    var musicID: String?
    @IBOutlet var musicTitleLabel: UILabel!
    @IBOutlet var musicDetailsLabel: UILabel!
    @IBOutlet var musicCoverImageView: UIImageView!
    @IBOutlet var appleMusicButton: UIButton!
    @IBOutlet var spotifyButton: UIButton!
    
    fileprivate static var musicDetailsCache: LRUCache = LRUCache(sizeLimit: 5)
    
    @IBAction func appleMusicButtonAction(_ sender: Any) {
        guard let cacheEntry = MusicDetailsController.musicDetailsCache.get(value: self.musicID!) else {
            self.setupDefaultView()
            return
        }
        guard let musicDetails = cacheEntry.getObjectData() as! MusicDetails? else {
            self.setupDefaultView()
            return
        }
        if let url = URL(string: APPLEMUSIC_URL_PREFIX + musicDetails.AppleMusicID) {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    @IBAction func spotifyMusicButtonAction(_ sender: Any) {
        guard let cacheEntry = MusicDetailsController.musicDetailsCache.get(value: self.musicID!) else {
            self.setupDefaultView()
            return
        }
        guard let musicDetails = cacheEntry.getObjectData() as! MusicDetails? else {
            self.setupDefaultView()
            return
        }
        if let url = URL(string: SPOTIFY_URL_PREFIX + musicDetails.spotifyTrackID) {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Register network change events and attempt to fetch the music details when the view loads
        NetworkAvailability.setupReachability(controller: self, selector: #selector(self.reachabilityChanged(note:)) )
        fetchMusicDetails()
    }
    
    @objc func reachabilityChanged(note: Notification) {
        
        let reachability = note.object as! Reachability
        
        if(reachability.connection != .none) {
            // When the network returns, try to fetch the music details again
            NetworkAvailability.networkAvailable = true
            self.fetchMusicDetailsAfterNetworkReturned()
        }
        else {
            // When the network is disconnected, then show an alert to the user
            NetworkAvailability.networkAvailable = false
            NetworkAvailability.displayNetworkDisconnectedAlert(currentUIViewController: self)
        }
    }

    func fetchMusicDetailsAfterNetworkReturned() {
        // When the network returns, wait momentarily and then try to fetch the music details again
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.fetchMusicDetails()
        }
    }
    
    func setupDefaultView() {
        // Used when the network is down and the cache can't be updated with a new entry
        self.musicTitleLabel.text = "Unavailable"
        self.musicDetailsLabel.text = "Try again later."
        self.musicCoverImageView.image = UIImage(named: "NoConnection")
        self.spotifyButton.isHidden = true
        self.appleMusicButton.isHidden = true
    }
    
    func setupView(withDetails: MusicDetails) {
        // Used when there is a valid cache entry to display music details
        self.musicTitleLabel.text = withDetails.albumTitle
        self.musicDetailsLabel.text = withDetails.songTitle
        self.musicCoverImageView.image = MusicDataManager.GetInstance()?.getMusicCoverImage(atIndex: withDetails.index)
        self.spotifyButton.isHidden = false
        self.appleMusicButton.isHidden = false
    }
    
    func dispatchViewUpdate () {
        DispatchQueue.main.async {
            // When there is no cache entry (likely due to network being down) then just
            // show the default view indicating information is unavailable
            guard let cacheEntry = MusicDetailsController.musicDetailsCache.get(value: self.musicID!) else {
                self.setupDefaultView()
                return
            }
            // When there is a cache entry but the music details are missing, then just
            // show the default view indicating information is unavailable
            guard let musicDetails = cacheEntry.getObjectData() as! MusicDetails? else {
                self.setupDefaultView()
                return
            }
            // Otherwise, take the information from cache and show the music details
            self.setupView(withDetails: musicDetails)
        }
    }
    
    func requestMusicDetails() {
        let successHandler = { (receivedData: Data?) -> Void in
            let pMusicDataManager = MusicDataManager.GetInstance()
            guard let musicDetails = pMusicDataManager?.decodeMusicDetails(receivedJSONData: receivedData) else {
                print("JSON data parsing failed.")
                self.dispatchViewUpdate()
                return
            }
            
            // Otherwise, add the music details to the cache
            let newEntry = MusicDetailsController.musicDetailsCache.add(value: self.musicID!)
            newEntry?.setObjectData(object: musicDetails as AnyObject)
            
            // And then update the view with what was just stored in cache
            self.dispatchViewUpdate()
        }
        
        let errorHandler = { () -> Void in
            self.dispatchViewUpdate()
        }
        
        EndpointRequestor.requestEndpointData(endpoint: .MUSIC_DETAILS,
                                              withUIViewController: self,
                                              errorHandler: errorHandler,
                                              successHandler: successHandler,
                                              busyTheView: true,
                                              withArgument: musicID as AnyObject?)
    }
    
    func fetchMusicDetails() {
        // When the music ID is valid
        if(musicID != nil && musicID != "") {
            // And the music details are not in cache and the network is available
            if( MusicDetailsController.musicDetailsCache.isValid(value: musicID!) == false &&
                NetworkAvailability.networkAvailable == true) {
                // Then request the music details from the cloud
                self.requestMusicDetails()
            }
            else {
                // Otherwise, show what is in cache or indicate information is unavailable
                // since the network is down
                self.dispatchViewUpdate()
            }
        }
    }
}
