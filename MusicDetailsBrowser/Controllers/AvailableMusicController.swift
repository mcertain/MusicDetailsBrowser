//
//  AvailableMusicController.swift
//  MusicDetailsBrowser
//
//  Created by Matthew Certain on 4/15/19.
//  Copyright © 2019 M. Certain. All rights reserved.
//

import UIKit

class AvailableMusicController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Register for network change events
        NetworkAvailability.setupReachability(controller: self, selector: #selector(self.reachabilityChanged(note:)) )
    }
    
    @objc func reachabilityChanged(note: Notification) {
        
        let reachability = note.object as! Reachability
        if(reachability.connection != .none) {
            // Once the network is confirmed to be available, then fetch the music list data
            NetworkAvailability.networkAvailable = true
            self.fetchMusicData()
        }
        else {
            // When the network is disconnected, then show an alert to the user
            NetworkAvailability.networkAvailable = false
            NetworkAvailability.displayNetworkDisconnectedAlert(currentUIViewController: self)
        }
    }
    
    func fetchMusicData() {
        // When the Music Data Manager is empty, then query the music list from the cloud
        if(MusicDataManager.GetInstance()?.getMusicCount() == 0) {
            let remoteLocation = URL(string: MUSIC_LIST_URL)
            let task = URLSession.shared.dataTask(with: remoteLocation!) {(data, response, error) in
                guard error == nil else {
                    print("URL Request returned with error.")
                    return
                }
                
                guard let content = data else {
                    print("There was no data at the requested URL.")
                    return
                }
                
                guard (MusicDataManager.GetInstance()?.storeMusicData(receivedJSONData: content))! else {
                    print("JSON data parsing failed.")
                    return
                }
                
                // When the data is successfully retrieved and stored, then reload the table data
                // from the Music Data Manager's cache
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            task.resume()
        }
    }
    
    func fetchMusicCoverImage(forCell: MusicListCell, atIndex: Int, withID: String) {
        let remoteLocation = MusicDataManager.GetInstance()?.getCoverImageThumbURL(atIndex: atIndex)
        let task = URLSession.shared.dataTask(with: remoteLocation!) {(data, response, error) in
            guard error == nil else {
                print("URL Request returned with error.")
                return
            }
            
            guard let content = data else {
                print("There was no data at the requested URL.")
                return
            }
            
            // Store the Music Cover Image in the Music Data Manager's cache
            MusicDataManager.GetInstance()?.setMusicCoverImage(atIndex: atIndex, withData: content)
            
            // Then update only the cell that needs to display the music cover image
            DispatchQueue.main.async {
                forCell.musicCoverImage.image = UIImage(data: content)
            }
        }
        task.resume()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (MusicDataManager.GetInstance()?.getMusicCount())!
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return MUSIC_LIST_CELL_HEIGHT
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: MusicListCell
        let idx:Int = indexPath.row
        let pMusicDataManager = MusicDataManager.GetInstance()
        
        // Load the default cell layout and populate it
        cell = Bundle.main.loadNibNamed("MusicListCell", owner: self, options: nil)?.first as! MusicListCell
        cell.songTitle.text = pMusicDataManager?.getSongTitle(atIndex: idx)
        cell.albumTitle.text = pMusicDataManager?.getAlbumTitle(atIndex: idx)
        
        // If the music cover image hasn't be stored in cache yet, then fetch and store it
        let coverImage = pMusicDataManager?.getMusicCoverImage(atIndex: idx)
        if(coverImage == nil) {
            self.fetchMusicCoverImage(forCell: cell,
                                      atIndex: idx,
                                      withID: (pMusicDataManager?.getMusicID(atIndex: idx))!)
        }
        else {
            cell.musicCoverImage.image = coverImage
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // When a table cell is touched, then load and open music details view for music selected
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        if let pMusicDetailsController = mainStoryBoard.instantiateViewController(withIdentifier: "MusicDetailsController") as? MusicDetailsController {
            let idx:Int = indexPath.row
            let pMusicDataManager = MusicDataManager.GetInstance()
            pMusicDetailsController.musicID = pMusicDataManager?.getMusicID(atIndex: idx)
            navigationController?.pushViewController(pMusicDetailsController, animated: true)
        }
        else {
            print("Could not load the Chat Message Controller view controller")
            return
        }
    }


}
