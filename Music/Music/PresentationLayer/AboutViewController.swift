//
//  AboutViewController.swift
//  Music
//
//  Created by Bagas Ilham on 28/05/22.
//

import UIKit

final class AboutViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "User Manual"
        case 1:
            return "About"
        default:
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.selectionStyle = .none
        cell.textLabel?.numberOfLines = 0
        
        switch section {
        case 0:
            cell.textLabel?.text =
"""
1. To play a song, first you'll have to create a music queue. Press the "+" button at the upper right of the screen.\n
2. There will be 5 default music in the list. Add a song to the queue by swiping right on the music you want to add.\n
3. You can add the same song to queue multiple times.\n
4. If you want to remove a song from the queue, swipe right on the music in the queue section.\n
5. Press "Done" and the queue will be made.\n
6. You can play the next in the queue by pressing the "⏭" button. Pressing the "⏮" button when the currently playing music over 2 seconds elapsed will make the playback restarted. On the contrary, the playback will play the previous music in the queue. You can also pause and play the music playback by pressing the "▶️" and "⏸" button.\n
7. Seek the music playback by dragging the slider as you wish.\n
8. Currently playing music also available at the notification center and control center.\n
9. Playback will continue in the background even when you're outside the app. Force closing the app will stop the playback.\n
10. Don't worry, your queue will always saved too if you accidentally closed the app.\n
11. Enjoy!
"""
            
        case 1:
            cell.textLabel?.textColor = .secondaryLabel
            cell.textLabel?.text =
"""
"Music" is an audio playback app created for Binar Academy submission.\n
Created by Bagas Ilham Rabbani.
"""
            
        default:
            return UITableViewCell()
        }
        return cell
    }
    
    func setupNavigationBar() {
        title = "About"
        let dismissButton = UIBarButtonItem(
            image: UIImage(systemName: "xmark"),
            style: .plain,
            target: self,
            action: #selector(dismissView)
        )
        dismissButton.tintColor = .systemPink
        navigationItem.rightBarButtonItem = dismissButton
    }
    
    @objc func dismissView() {
        self.dismiss(animated: true)
    }
}
