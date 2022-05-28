//
//  QueueViewController.swift
//  Music
//
//  Created by Bagas Ilham on 28/05/22.
//

import UIKit

final class QueueViewController: UITableViewController {
    
    var displayedMusic: [Music] = []
    var queuedMusic: [Music]?
    
    typealias OnDoneButtonTap = ([Music]) -> Void
    var onDoneButtonTap: OnDoneButtonTap?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        setupNavigationBar()
        displayedMusic = loadDefaultMusicList()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return displayedMusic.count
        case 1:
            return queuedMusic?.count ?? 0
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Music List"
        case 1:
            return "Queued"
        default:
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let row = indexPath.row
        let section = indexPath.section
        var music: Music?
        switch section {
        case 0:
            music = displayedMusic[row]
        case 1:
            music = queuedMusic?[row]
        default:
            return UITableViewCell()
        }
        guard let music = music else { return UITableViewCell() }

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
        return cell
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let section = indexPath.section
        let row = indexPath.row
        
        switch section {
        case 0:
            let queue = UIContextualAction(
                style: .normal,
                title: "Add to queue"
            ) { [weak self] action, view, completion in
                guard let _self = self else { return }
                if _self.queuedMusic == nil {
                    _self.queuedMusic = []
                }
                DispatchQueue.main.async {
                    _self.queuedMusic?.append(_self.displayedMusic[row])
                    _self.tableView.insertRows(at: [IndexPath(row: (_self.queuedMusic?.count ?? 0) - 1, section: 1)], with: .automatic)
                    completion(true)
                }
                
            }
            queue.backgroundColor = .systemYellow
            queue.image = UIImage(systemName: "pin.fill")
            let swipeActions = UISwipeActionsConfiguration(actions: [queue])
            return swipeActions
            
        case 1:
            let delete = UIContextualAction(
                style: .destructive,
                title: "Remove from queue"
            ) { [weak self] action, view, completion in
                guard let _self = self else { return }
                DispatchQueue.main.async {
                    _self.queuedMusic?.remove(at: row)
                    _self.tableView.deleteRows(at: [indexPath], with: .automatic)
                    completion(true)
                }
//
//                _self.tableView.reloadData()
            }
            delete.image = UIImage(systemName: "pin.slash.fill")
            let swipeActions = UISwipeActionsConfiguration(actions: [delete])
            return swipeActions
            
        default:
            return nil
        }
    }
    
    func loadDefaultMusicList() -> [Music] {
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
        tableView.reloadData()
        return musicList
    }
    
    func setupNavigationBar() {
        title = "Create music queue"
        let doneButton = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(createQueue)
        )
        doneButton.tintColor = .systemPink
        navigationItem.rightBarButtonItem = doneButton
        let cancelButton = UIBarButtonItem(
            barButtonSystemItem: .cancel,
            target: self,
            action: #selector(dismissViewController)
        )
        cancelButton.tintColor = .systemPink
        navigationItem.leftBarButtonItem = cancelButton
    }
    
    @objc func createQueue() {
        tableView.reloadData()
        onDoneButtonTap?(queuedMusic ?? [])
        self.dismiss(animated: true)
    }
    
    @objc func dismissViewController() {
        self.dismiss(animated: true)
    }
    
}
