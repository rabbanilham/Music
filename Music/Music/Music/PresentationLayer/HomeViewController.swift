//
//  HomeViewController.swift
//  Music
//
//  Created by Bagas Ilham on 27/05/22.
//

import UIKit
import AVFoundation
import MediaPlayer

final class HomeViewController: UITableViewController {
    
    var musicQueue: [Music] = []
    var player: AVPlayer?
    var isPlaying: Bool = false
    var currentPlayedMusicIndex: Int = 0
    var currentPlayedMusic: AVPlayerItem?
    var currentTime: Float64?
    var timer: Timer = Timer()
    var albumCoverImageView: UIImageView = UIImageView()
    var trackTitleLabel: UILabel = UILabel()
    var trackArtistLabel: UILabel = UILabel()
    var trackTimeLabel: UILabel = UILabel()
    var trackLengthLabel: UILabel = UILabel()
    var playNextButton: UIButton = UIButton(configuration: .borderedTinted())
    var playPreviousButton: UIButton = UIButton(configuration: .borderedTinted())
    var playPauseButton: UIButton = UIButton(configuration: .filled())
    var playerProgressSlider: UISlider = UISlider()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "playerCell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "queueCell")
        NotificationCenter.default.addObserver(
            self, selector: #selector(onNextButtonPressed),
            name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
            object: player?.currentItem
        )
        setupNavigationBar()
        setupAudioBackground()
        setupPlayer()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 1:
            return "In queue"
        default:
            return nil
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 1:
            return musicQueue.count
        default:
            return 1
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let row = indexPath.row
        let section = indexPath.section
        

        switch section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "playerCell", for: indexPath)
            let view = cell.contentView
            view.addSubview(albumCoverImageView)
            view.addSubview(trackTitleLabel)
            view.addSubview(trackArtistLabel)
            view.addSubview(trackTimeLabel)
            view.addSubview(trackLengthLabel)
            view.addSubview(playNextButton)
            view.addSubview(playPreviousButton)
            view.addSubview(playPauseButton)
            view.addSubview(playerProgressSlider)
            
            if isPlaying == false {
                playPauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
            } else {
                playPauseButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
            }

            NSLayoutConstraint.activate([
                albumCoverImageView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 10),
                albumCoverImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                albumCoverImageView.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor),
                albumCoverImageView.heightAnchor.constraint(equalTo: albumCoverImageView.widthAnchor),

                trackTitleLabel.topAnchor.constraint(equalTo: albumCoverImageView.bottomAnchor, constant: 10),
                trackTitleLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
                
                trackArtistLabel.topAnchor.constraint(equalTo: trackTitleLabel.bottomAnchor),
                trackArtistLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
                
                playPauseButton.topAnchor.constraint(equalTo: trackArtistLabel.bottomAnchor, constant: 20),
                playPauseButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                playPauseButton.heightAnchor.constraint(equalToConstant: 70),
                playPauseButton.widthAnchor.constraint(equalTo: playPauseButton.heightAnchor),
                
                playNextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 100),
                playNextButton.centerYAnchor.constraint(equalTo: playPauseButton.centerYAnchor),

                playPreviousButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -100),
                playPreviousButton.centerYAnchor.constraint(equalTo: playPauseButton.centerYAnchor),
               
                playerProgressSlider.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                playerProgressSlider.topAnchor.constraint(equalTo: playPauseButton.bottomAnchor, constant: 10),
                playerProgressSlider.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor),
                
                trackTimeLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
                trackTimeLabel.topAnchor.constraint(equalTo: playerProgressSlider.bottomAnchor, constant: 10),
                
                trackLengthLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
                trackLengthLabel.topAnchor.constraint(equalTo: playerProgressSlider.bottomAnchor, constant: 10),
                trackLengthLabel.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor,constant: -10)
            ])
            cell.selectionStyle = .none
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "queueCell", for: indexPath)
//            let view = cell.contentView
            let music = musicQueue[row]
            let attrTitle: NSMutableAttributedString = NSMutableAttributedString(
                string: music.title,
                attributes: [.font : UIFont.systemFont(ofSize: 16, weight: .bold)]
            )
            let attrArtist: NSMutableAttributedString = NSMutableAttributedString(
                string: " — by \(music.artist)",
                attributes: [.font : UIFont.systemFont(ofSize: 14, weight: .regular), .foregroundColor : UIColor.secondaryLabel]
            )
            attrTitle.append(attrArtist)
            cell.textLabel?.attributedText = attrTitle
            cell.selectionStyle = .none
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func setupNavigationBar() {
        title = "Music Player"
        navigationController?.navigationBar.prefersLargeTitles = true
        let addButton = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(goToQueueViewController)
        )
        addButton.tintColor = .systemPink
        navigationItem.rightBarButtonItem = addButton
    }
    
    func stringFromTimeInterval(interval: TimeInterval) -> String {
        let interval = Int(interval)
        let seconds = interval % 60
        let minutes = (interval / 60) % 60
//        let hours = (interval / 3600)
        return String(format: "%02d.%02d", minutes, seconds)
    }

    func setupPlayer() {
        var musicTitle: String?
        var musicArtist: String?
        var fileUrl: URL?
        var playerItem: AVPlayerItem?
        var trackDuration: CMTime?
        var trackDurationSecondsCount: Float64?
        var currentSecond: CMTime?
        var currentSecondSecondsCount: Float64?
        if !(musicQueue.isEmpty) {
            albumCoverImageView.image = musicQueue[currentPlayedMusicIndex].albumCover
            musicTitle = musicQueue[currentPlayedMusicIndex].title
            trackTitleLabel.text = musicTitle
            musicArtist = musicQueue[currentPlayedMusicIndex].artist
            trackArtistLabel.text = musicArtist
            let fileName = [musicTitle!, musicArtist!].joined(separator: " - ")
            fileUrl = Bundle.main.url(forResource: fileName, withExtension: "mp3")
            playerItem = AVPlayerItem(url: fileUrl!)
            currentPlayedMusic = playerItem
            
            trackDuration = playerItem?.asset.duration ?? CMTime(value: 0, timescale: .min)
            trackDurationSecondsCount = CMTimeGetSeconds(trackDuration!)
            
            currentSecond = playerItem?.currentTime() ?? CMTime(value: 0, timescale: .min)
            currentSecondSecondsCount = CMTimeGetSeconds(currentSecond!)
        }
        player = AVPlayer(playerItem: playerItem)
        player?.addPeriodicTimeObserver(
            forInterval: CMTimeMakeWithSeconds(1, preferredTimescale: 1),
            queue: DispatchQueue.main
        ) { (CMTime) -> Void in
            if self.player!.currentItem?.status == .readyToPlay {
                let time : Float64 = CMTimeGetSeconds((self.player?.currentTime())!)
                self.playerProgressSlider.value = Float (time)
                self.trackTimeLabel.text = self.stringFromTimeInterval(interval: time)
                self.currentTime = time
            }
        }
        
        albumCoverImageView.translatesAutoresizingMaskIntoConstraints = false
        albumCoverImageView.layer.cornerRadius = 10
        albumCoverImageView.clipsToBounds = true
        
        trackTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        trackTitleLabel.font = .systemFont(ofSize: 20, weight: .bold)
        
        trackArtistLabel.translatesAutoresizingMaskIntoConstraints = false
        trackArtistLabel.font = .systemFont(ofSize: 15, weight: .regular)
        trackArtistLabel.textColor = .secondaryLabel
        
        trackLengthLabel.text = self.stringFromTimeInterval(interval: trackDurationSecondsCount ?? 0)
        trackLengthLabel.font = .systemFont(ofSize: 12, weight: .bold)
        trackLengthLabel.translatesAutoresizingMaskIntoConstraints = false
        
        trackTimeLabel.text = self.stringFromTimeInterval(interval: currentSecondSecondsCount ?? 0)
        trackTimeLabel.font = .systemFont(ofSize: 12, weight: .bold)
        trackTimeLabel.translatesAutoresizingMaskIntoConstraints = false

        playNextButton.translatesAutoresizingMaskIntoConstraints = false
        playNextButton.setImage(UIImage(systemName: "forward.fill"), for: .normal)
        playNextButton.addTarget(self, action: #selector(onNextButtonPressed), for: .touchUpInside)
        playNextButton.tintColor = .systemPink

        playPreviousButton.translatesAutoresizingMaskIntoConstraints = false
        playPreviousButton.setImage(UIImage(systemName: "backward.fill"), for: .normal)
        playPreviousButton.tintColor = .systemPink
        playPreviousButton.addTarget(self, action: #selector(onPreviousButtonPressed), for: .touchUpInside)

        playPauseButton.translatesAutoresizingMaskIntoConstraints = false
        playPauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        playPauseButton.addTarget(self, action: #selector(onPlayButtonPressed), for: .touchUpInside)
        playPauseButton.layer.cornerRadius = 35
        playPauseButton.clipsToBounds = true
        playPauseButton.tintColor = .systemPink

        playerProgressSlider.translatesAutoresizingMaskIntoConstraints = false
        playerProgressSlider.minimumValue = 0
        playerProgressSlider.maximumValue = Float(trackDurationSecondsCount ?? 120)
        playerProgressSlider.thumbTintColor = .label
        playerProgressSlider.isContinuous = true
        playerProgressSlider.tintColor = .systemPink
        playerProgressSlider.addTarget(self, action: #selector(onPlayerProgressSliderValueChanged(_:)), for: .valueChanged)
    }
    
    func setupAudioBackground() {
        do {
            try AVAudioSession.sharedInstance().setCategory(
                .playback,
                mode: .default,
                options: []
            )
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print(String(describing: error))
        }
    }
    
    func setupRemoteCommandCenter() {
        guard let player = player,
              let musicTitle = trackTitleLabel.text,
              let musicArtist = trackArtistLabel.text
//              let currentPlayedMusic = currentPlayedMusic
        else { return }
        let fileName = [musicTitle, musicArtist].joined(separator: " - ")
        let albumCoverImage: UIImage = UIImage(named: fileName)!
        let mediaArtwork: MPMediaItemArtwork = MPMediaItemArtwork(boundsSize: albumCoverImage.size) { size in
            return albumCoverImage
        }
        let musicInfo: [String: Any] = [
            MPMediaItemPropertyTitle: trackTitleLabel.text ?? "",
            MPMediaItemPropertyArtist: trackArtistLabel.text ?? "",
            MPMediaItemPropertyArtwork : mediaArtwork,
//            MPNowPlayingInfoPropertyElapsedPlaybackTime : "\(currentTime)",
//            MPMediaItemPropertyPlaybackDuration : "\(currentPlayedMusic.duration)",
            MPNowPlayingInfoPropertyPlaybackRate : player.rate
        ]
        MPNowPlayingInfoCenter.default().nowPlayingInfo = musicInfo
        let commandCenter = MPRemoteCommandCenter.shared()
        commandCenter.playCommand.isEnabled = true
        commandCenter.playCommand.addTarget { [weak self] (event) -> MPRemoteCommandHandlerStatus in
            guard let _self = self else { return .success }
            _self.player?.play()
            print("Play Music")
            return .success
        }
        
        commandCenter.pauseCommand.isEnabled = true
        commandCenter.pauseCommand.addTarget { [weak self] (event) -> MPRemoteCommandHandlerStatus in
            guard let _self = self else { return .success }
            _self.player?.pause()
            print("Pause Music")
            return .success
        }
        
        commandCenter.stopCommand.isEnabled = true
        commandCenter.stopCommand.addTarget { [weak self] event -> MPRemoteCommandHandlerStatus in
            guard let _self = self else { return .success }
            _self.player?.pause()
            print("Stop Music")
            return .success
        }
        
        commandCenter.nextTrackCommand.isEnabled = true
        commandCenter.nextTrackCommand.addTarget { [weak self] event -> MPRemoteCommandHandlerStatus in
            guard let _self = self else { return .success }
            _self.playNextMusicInQueue()
            return.success
        }
        
        commandCenter.previousTrackCommand.isEnabled = true
        commandCenter.previousTrackCommand.addTarget { [weak self] event -> MPRemoteCommandHandlerStatus in
            guard let _self = self else { return .success }
            _self.playPreviousMusicInQueue()
            return.success
        }
    }
    
    @objc func onPlayButtonPressed() {
        isPlaying.toggle()
        playOrPauseMusic()
        setupRemoteCommandCenter()
    }
    
    func playOrPauseMusic() {
        if player?.rate == 0 {
            player!.play()
        } else {
            player!.pause()
        }
        tableView.reloadData()
    }
    
    @objc func onNextButtonPressed() {
        playNextMusicInQueue()
    }
    
    func playNextMusicInQueue() {
        currentPlayedMusicIndex += 1
        if currentPlayedMusicIndex == musicQueue.count {
            currentPlayedMusicIndex = 0
        }
        setupPlayer()
        tableView.reloadData()
        player?.play()
        setupRemoteCommandCenter()
    }
    
    @objc func onPreviousButtonPressed() {
        playPreviousMusicInQueue()
    }
    
    func playPreviousMusicInQueue() {
        if (currentTime ?? 0) > 2 {
            player?.seek(to: CMTimeMake(value: 0, timescale: 1))
        } else {
            currentPlayedMusicIndex -= 1
            if currentPlayedMusicIndex == -1 {
                currentPlayedMusicIndex = 0
            }
            setupPlayer()
            tableView.reloadData()
            player?.play()
        }
        setupRemoteCommandCenter()
    }
    
    @objc func onPlayerProgressSliderValueChanged(_ playbackSlider: UISlider) {
        let seconds: Int64 = Int64(playbackSlider.value)
        let targetTime: CMTime = CMTimeMake(value: seconds, timescale: 1)
        player?.seek(to: targetTime)
        
        if player?.rate == 0 {
            player?.play()
            isPlaying = true
            tableView.reloadData()
        }
    }
    
    @objc func goToQueueViewController() {
        let viewController = QueueViewController()
        viewController.queuedMusic = musicQueue
        let navigator = UINavigationController(rootViewController: viewController)
        navigationController?.present(navigator, animated: true)
        viewController.onDoneButtonTap = { [weak self] queue in
            guard let _self = self else { return }
            _self.musicQueue = queue
            _self.setupPlayer()
            _self.tableView.reloadData()
            _self.setupAudioBackground()
            _self.setupRemoteCommandCenter()
        }
    }
    
}
