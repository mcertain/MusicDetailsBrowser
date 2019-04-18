//
//  MovieListCell.swift
//  MusicDetailsBrowser
//
//  Created by Matthew Certain on 4/15/19.
//  Copyright © 2019 M. Certain. All rights reserved.
//

import Foundation
import UIKit

let MOVIE_LIST_CELL_HEIGHT: CGFloat = 90

class MovieListCell : UITableViewCell {
    @IBOutlet var movieCoverImage: UIImageView!
    @IBOutlet var movieTitle: UILabel!
    
    let coverImageNew: UIImageView = {
        return UIImageView()
    }()
    
    let movieTitleNew: UILabel = {
        return UILabel()
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        movieCoverImage = coverImageNew
        movieTitle = movieTitleNew
        
        self.addSubview(movieCoverImage)
        self.addSubview(movieTitle)
        
        movieCoverImage.setAnchors(top: self.contentView.topAnchor, topPad: 5,
                                  bottom: self.contentView.bottomAnchor, bottomPad: 5,
                                  left: self.contentView.leftAnchor, leftPad: 5)
        
        movieTitle.setAnchors(top: self.contentView.topAnchor, topPad: 25,
                             left: self.contentView.leftAnchor, leftPad: 65,
                             right: self.contentView.rightAnchor, rightPad: 5)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
