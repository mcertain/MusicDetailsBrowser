//
//  EndpointRequestor.swift
//  MusicDetailsBrowser
//
//  Created by Matthew Certain on 4/18/19.
//  Copyright © 2019 M. Certain. All rights reserved.
//

import Foundation
import UIKit

enum Endpoints: Int {
    case MUSIC_LISTING
    case MUSIC_DETAILS
    case COVER_IMAGE_THUMBNAIL
}

class EndpointRequestor {
    
    static func requestEndpointData(endpoint: Endpoints,
                                    withUIViewController: UIViewController,
                                    errorHandler: (() -> Void)?,
                                    successHandler: ((_ receivedData: Data?) -> Void)?,
                                    busyTheView: Bool,
                                    withArgument: AnyObject?=nil) {
        var remoteLocation: URL?
        switch endpoint {
        case .MUSIC_LISTING:
            remoteLocation = URL(string: MUSIC_LIST_URL)
        case .MUSIC_DETAILS:
            remoteLocation = URL(string: MUSIC_DETAILS_URL + "/" + (withArgument as! String))
        case .COVER_IMAGE_THUMBNAIL:
            remoteLocation = MusicDataManager.GetInstance()?.getCoverImageThumbURL(atIndex: (withArgument as! Int))
        }
        
        guard remoteLocation != nil else {
            return
        }
        
        // Just incase it takes a while to get a response, busy the view so the user knows something
        // is happening
        var busyViewOverlay: UIViewController?
        if(busyTheView == true) {
            busyViewOverlay = withUIViewController.busyTheViewWithIndicator(currentUIViewController: withUIViewController)
        }
        let task = URLSession.shared.dataTask(with: remoteLocation!) {(data, response, error) in
            // Once the response comes back, then the view can be unbusied and updated
            if(busyTheView == true) {
                withUIViewController.unbusyTheViewWithIndicator(busyView: busyViewOverlay)
            }
            
            // For issues, dispatch the default view indicating the information is unavailable
            guard error == nil else {
                print("URL Request returned with error.")
                errorHandler?()
                return
            }
            guard let content = data else {
                print("There was no data at the requested URL.")
                errorHandler?()
                return
            }
            
            successHandler?(content)
        }
        task.resume()
    }
}
