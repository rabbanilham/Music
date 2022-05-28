//
//  Music.swift
//  Music
//
//  Created by Bagas Ilham on 28/05/22.
//

import Foundation
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
    
    static func defaultMusicList() -> [Music] {
        var musicList: [Music] = []
        let music1: Music = Music(
            title: "Island Life",
            artist: "Atomic Drum Assembly",
            fileURL: Bundle.main.url(forResource: "Island Life - Atomic Drum Assembly", withExtension: "mp3")!,
            albumCover: UIImage(named: "Island Life - Atomic Drum Assembly") ?? UIImage(systemName: "music.note")!
        )
        let music2: Music = Music(
            title: "Purusha",
            artist: "NVDES",
            fileURL: Bundle.main.url(forResource: "Purusha - NVDES", withExtension: "mp3")!,
            albumCover: UIImage(named: "Purusha - NVDES") ?? UIImage(systemName: "music.note")!
        )
        let music3: Music = Music(
            title: "Overtime",
            artist: "Cash Cash",
            fileURL: Bundle.main.url(forResource: "Overtime - Cash Cash", withExtension: "mp3")!,
            albumCover: UIImage(named: "Overtime - Cash Cash") ?? UIImage(systemName: "music.note")!
        )
        let music4: Music = Music(
            title: "Chimes",
            artist: "Hudson Mohawke",
            fileURL: Bundle.main.url(forResource: "Chimes - Hudson Mohawke", withExtension: "mp3")!,
            albumCover: UIImage(named: "Chimes - Hudson Mohawke") ?? UIImage(systemName: "music.note")!
        )
        let music5: Music = Music(
            title: "Poison",
            artist: "Martin Garrix",
            fileURL: Bundle.main.url(forResource: "Poison - Martin Garrix", withExtension: "mp3")!,
            albumCover: UIImage(named: "Poison - Martin Garrix") ?? UIImage(systemName: "music.note")!
        )
        musicList.append(music1)
        musicList.append(music2)
        musicList.append(music3)
        musicList.append(music4)
        musicList.append(music5)
        return musicList
    }

}
