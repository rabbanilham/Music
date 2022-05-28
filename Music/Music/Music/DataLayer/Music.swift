//
//  Music.swift
//  Music
//
//  Created by Bagas Ilham on 28/05/22.
//

import UIKit

struct Music {
    var title: String
    var artist: String
    var fileURL: URL
    var albumCover: UIImage
    
    init(title: String, artist: String, fileURL: URL, albumCover: UIImage) {
        self.title = title
        self.artist = artist
        self.fileURL = fileURL
        self.albumCover = albumCover
    }
}
