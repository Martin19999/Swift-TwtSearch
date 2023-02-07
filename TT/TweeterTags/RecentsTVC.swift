//
//  RecentsTVC.swift
//  TweeterTags
//
//  Created by ActualChilli on 2022/12/1.
//

import UIKit

class RecentsTVC: UITableViewController {
    
    let tweetsTVC = TweetsTVC()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view datasource

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tweetsTVC.history.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "HIstoryId", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = tweetsTVC.history[tweetsTVC.history.index(tweetsTVC.history.endIndex, offsetBy: -indexPath.row-1)]

        return cell
    }
    

  
}
