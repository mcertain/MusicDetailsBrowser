//
//  AvailableMoviesController.swift
//  MusicDetailsBrowser
//
//  Created by Matthew Certain on 4/15/19.
//  Copyright © 2019 M. Certain. All rights reserved.
//

import UIKit

class AvailableMoviesController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Register for network change events
        NetworkAvailability.setupReachability(controller: self, selector: #selector(self.reachabilityChanged(note:)) )
    }
    
    @objc func reachabilityChanged(note: Notification) {
        
        let reachability = note.object as! Reachability
        if(reachability.connection != .none) {
            // Once the network is confirmed to be available, then fetch the movie list data
            NetworkAvailability.networkAvailable = true
            self.fetchMovieData()
        }
        else {
            // When the network is disconnected, then show an alert to the user
            NetworkAvailability.networkAvailable = false
            NetworkAvailability.displayNetworkDisconnectedAlert(currentUIViewController: self)
        }
    }
    
    func fetchMovieData() {
        // When the Movie Data Manager is empty, then query the movie list from the cloud
        if(MovieDataManager.GetInstance()?.getMovieCount() == 0) {
            let remoteLocation = URL(string: MOVIES_LIST_URL)
            let task = URLSession.shared.dataTask(with: remoteLocation!) {(data, response, error) in
                guard error == nil else {
                    print("URL Request returned with error.")
                    return
                }
                
                guard let content = data else {
                    print("There was no data at the requested URL.")
                    return
                }
                
                guard (MovieDataManager.GetInstance()?.storeMovieData(receivedJSONData: content))! else {
                    print("JSON data parsing failed.")
                    return
                }
                
                // When the data is successfully retrieved and stored, then reload the table data
                // from the Movie Data Manager's cache
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            task.resume()
        }
    }
    
    func fetchMovieCoverImage(forCell: MovieListCell, atIndex: Int, withID: String) {
        let remoteLocation = MovieDataManager.GetInstance()?.getMovieImageURL(atIndex: atIndex)
        let task = URLSession.shared.dataTask(with: remoteLocation!) {(data, response, error) in
            guard error == nil else {
                print("URL Request returned with error.")
                return
            }
            
            guard let content = data else {
                print("There was no data at the requested URL.")
                return
            }
            
            // Store the Movie Cover Image in the Movie Data Manager's cache
            MovieDataManager.GetInstance()?.setMovieCoverImage(atIndex: atIndex, withData: content)
            
            // Then update only the cell that needs to display the movie cover image
            DispatchQueue.main.async {
                forCell.movieCoverImage.image = UIImage(data: content)
            }
        }
        task.resume()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (MovieDataManager.GetInstance()?.getMovieCount())!
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return MOVIE_LIST_CELL_HEIGHT
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: MovieListCell
        let idx:Int = indexPath.row
        let pMovieDataManager = MovieDataManager.GetInstance()
        
        // Load the default cell layout and populate it
        cell = Bundle.main.loadNibNamed("MovieListCell", owner: self, options: nil)?.first as! MovieListCell
        cell.movieTitle.text = pMovieDataManager?.getMovieTitle(atIndex: idx)
        
        // If the movie cover image hasn't be stored in cache yet, then fetch and store it
        let coverImage = pMovieDataManager?.getMovieCoverImage(atIndex: idx)
        if(coverImage == nil) {
            self.fetchMovieCoverImage(forCell: cell,
                                      atIndex: idx,
                                      withID: (pMovieDataManager?.getMovieID(atIndex: idx))!)
        }
        else {
            cell.movieCoverImage.image = coverImage
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // When a table cell is touched, then load and open movie details view for movie selected
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        if let pMovieDetailsController = mainStoryBoard.instantiateViewController(withIdentifier: "MovieDetailsController") as? MovieDetailsController {
            let idx:Int = indexPath.row
            let pMovieDataManager = MovieDataManager.GetInstance()
            pMovieDetailsController.movieID = pMovieDataManager?.getMovieID(atIndex: idx)
            navigationController?.pushViewController(pMovieDetailsController, animated: true)
        }
        else {
            print("Could not load the Chat Message Controller view controller")
            return
        }
    }


}

