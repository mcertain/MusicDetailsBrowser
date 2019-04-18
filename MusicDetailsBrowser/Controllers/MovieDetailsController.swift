//
//  MovieDetailsController.swift
//  MusicDetailsBrowser
//
//  Created by Matthew Certain on 4/16/19.
//  Copyright © 2019 M. Certain. All rights reserved.
//

import Foundation
import UIKit

class MovieDetailsController : UIViewController, UINavigationControllerDelegate {
    
    var movieID: String?
    @IBOutlet var movieTitleLabel: UILabel!
    @IBOutlet var movieDetailsLabel: UILabel!
    @IBOutlet var movieCoverImageView: UIImageView!
    
    fileprivate static var movieDetailsCache: LRUCache = LRUCache(sizeLimit: 5)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Register network change events and attempt to fetch the movie details when the view loads
        NetworkAvailability.setupReachability(controller: self, selector: #selector(self.reachabilityChanged(note:)) )
        fetchMovieDetails()
    }
    
    @objc func reachabilityChanged(note: Notification) {
        
        let reachability = note.object as! Reachability
        
        if(reachability.connection != .none) {
            // When the network returns, try to fetch the movie details again
            NetworkAvailability.networkAvailable = true
            self.fetchMovieDetailsAfterNetworkReturned()
        }
        else {
            // When the network is disconnected, then show an alert to the user
            NetworkAvailability.networkAvailable = false
            NetworkAvailability.displayNetworkDisconnectedAlert(currentUIViewController: self)
        }
    }

    func fetchMovieDetailsAfterNetworkReturned() {
        // When the network returns, wait momentarily and then try to fetch the movie details again
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.fetchMovieDetails()
        }
    }
    
    func setupDefaultView() {
        // Used when the network is down and the cache can't be updated with a new entry
        self.movieTitleLabel.text = "Unavailable"
        self.movieDetailsLabel.text = "Try again later."
        self.movieCoverImageView.image = UIImage(named: "NoConnection")
    }
    
    func setupView(withDetails: MovieDetails) {
        // Used when there is a valid cache entry to display movie details
        self.movieTitleLabel.text = withDetails.title
        self.movieDetailsLabel.text = String(withDetails.index)
        self.movieCoverImageView.image = MovieDataManager.GetInstance()?.getMovieCoverImage(atIndex: withDetails.index)
    }
    
    func dispatchViewUpdate () {
        DispatchQueue.main.async {
            // When there is no cache entry (likely due to network being down) then just
            // show the default view indicating information is unavailable
            guard let cacheEntry = MovieDetailsController.movieDetailsCache.get(value: self.movieID!) else {
                self.setupDefaultView()
                return
            }
            // When there is a cache entry but the movie details are missing, then just
            // show the default view indicating information is unavailable
            guard let movieDetails = cacheEntry.getObjectData() as! MovieDetails? else {
                self.setupDefaultView()
                return
            }
            // Otherwise, take the information from cache and show the movie details
            self.setupView(withDetails: movieDetails)
        }
    }
    
    func requestMovieDetails() {
        let pMovieDataManager = MovieDataManager.GetInstance()
        let remoteLocation = URL(string: MUSIC_DETAILS_URL + "/" + movieID!)
        
        // Just incase it takes a while to get a response, busy the view so the user knows something
        // is happening
        let busyViewOverlay = self.busyTheViewWithIndicator(currentUIViewController: self)
        let task = URLSession.shared.dataTask(with: remoteLocation!) {(data, response, error) in
            // Once the response comes back, then the view can be unbusied and updated
            self.unbusyTheViewWithIndicator(busyView: busyViewOverlay!)
            
            // For issues, dispatch the default view indicating the information is unavailable
            guard error == nil else {
                print("URL Request returned with error.")
                self.dispatchViewUpdate()
                return
            }
            guard let content = data else {
                print("There was no data at the requested URL.")
                self.dispatchViewUpdate()
                return
            }
            guard let movieDetails = pMovieDataManager?.decodeMovieDetails(receivedJSONData: content) else {
                print("JSON data parsing failed.")
                self.dispatchViewUpdate()
                return
            }
            
            // Otherwise, add the movie details to the cache
            let newEntry = MovieDetailsController.movieDetailsCache.add(value: self.movieID!)
            newEntry?.setObjectData(object: movieDetails as AnyObject)
            
            // And then update the view with what was just stored in cache
            self.dispatchViewUpdate()
        }
        task.resume()
    }
    
    func fetchMovieDetails() {
        // When the movie ID is valid
        if(movieID != nil && movieID != "") {
            // And the movie details are not in cache and the network is available
            if( MovieDetailsController.movieDetailsCache.isValid(value: movieID!) == false &&
                NetworkAvailability.networkAvailable == true) {
                // Then request the movie details from the cloud
                self.requestMovieDetails()
            }
            else {
                // Otherwise, show what is in cache or indicate information is unavailable
                // since the network is down
                self.dispatchViewUpdate()
            }
        }
    }
}
