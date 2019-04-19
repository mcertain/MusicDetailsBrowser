//
//  MusicListCell.swift
//  MusicDetailsBrowser
//
//  Created by Matthew Certain on 4/15/19.
//  Copyright © 2019 M. Certain. All rights reserved.
//

import Foundation
import UIKit

let MUSIC_LIST_CELL_HEIGHT: CGFloat = 90

class MusicListCell : UITableViewCell {
    @IBOutlet var musicCoverImage: UIImageView!
    @IBOutlet var songTitle: UILabel!
    @IBOutlet var albumTitle: UILabel!
    
    let coverImageNew: UIImageView = {
        return UIImageView()
    }()
    
    let songTitleNew: UILabel = {
        return UILabel()
    }()
    
    let albumTitleNew: UILabel = {
        return UILabel()
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        musicCoverImage = coverImageNew
        songTitle = songTitleNew
        albumTitle = albumTitleNew
        
        self.addSubview(musicCoverImage)
        self.addSubview(songTitle)
        self.addSubview(albumTitle)
        
        musicCoverImage.setAnchors(top: self.contentView.topAnchor, topPad: 5,
                                  bottom: self.contentView.bottomAnchor, bottomPad: 5,
                                  left: self.contentView.leftAnchor, leftPad: 5)
        
        songTitle.setAnchors(top: self.contentView.topAnchor, topPad: 25,
                             left: self.contentView.leftAnchor, leftPad: 90,
                             right: self.contentView.rightAnchor, rightPad: 5)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
