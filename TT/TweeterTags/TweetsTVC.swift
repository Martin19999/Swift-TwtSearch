//
//  TweetsTVC.swift
//  TweeterTags
//
//  Created by ActualChilli on 2022/11/20.
//

import UIKit

class TweetsTVC: UITableViewController {
    
    private var tweets = [[TwitterTweet]]()
    private let maxSearchHistory: Int = 100
    
    // persistence
    var history: [String] {
        get {
            return UserDefaults.standard.array(forKey: "UserHistory") as? [String] ?? []
        }
        set {
            if newValue != [""]{
                // dump the oldest one in order to add the newest one
                if UserDefaults.standard.array(forKey: "UserHistory")?.count ?? 0 == maxSearchHistory {
                    let oldArray = UserDefaults.standard.array(forKey: "UserHistory")!
                    UserDefaults.standard.removeObject(forKey: "UserHistory")
                    var newArray = Array(oldArray[1...])
                    newArray.append(newValue.last!)
                    UserDefaults.standard.set(newArray, forKey: "UserHistory")
                    self.tableView.reloadData()
        
                }else if UserDefaults.standard.array(forKey: "UserHistory")?.count ?? 0 < maxSearchHistory{
                    UserDefaults.standard.set(newValue, forKey: "UserHistory")
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    // query text field
    @IBOutlet weak var twitterQueryTextField: UITextField? {
        didSet {
            twitterQueryTextField?.autocorrectionType = .no
            twitterQueryTextField?.becomeFirstResponder()
            twitterQueryTextField?.delegate = self
            
        }
    }
    
    var twitterQueryText: String? {
        set { twitterQueryTextField?.text = newValue }
        get { twitterQueryTextField?.text }
    }

    // fetch tweets
    private func refresh() {
        tweets.removeAll()
        
        let request = TwitterRequest(search: twitterQueryText ?? "", count: 8)
        
        request.fetchTweets { (theTweets) -> Void in
            DispatchQueue.main.async { () -> Void in
                for tweet in theTweets {
                    self.tweets.append(contentsOf: [[tweet]])
                }
                self.tableView.reloadData()
            }
        }
        
        if twitterQueryText != "" {
            if twitterQueryText!.trimmingCharacters(in: .whitespaces) != "" {
                history.append(twitterQueryText!)
            }
            
        }
            
        
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
        return self.tweets.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetsCustomCell

        // Configure the cell...
        
        // 1. avatar
        let data = try? Data(contentsOf: tweets[indexPath.row][0].user.profileImageURL!)
        if let imageData = data {
            let image = UIImage(data: imageData)
            cell.tweetAvatar?.image = image
        }else {
            cell.tweetAvatar?.image = UIImage(systemName: "sparkles")
        }
        
        // 2. screen name
        cell.tweeterScreenName.text = tweets[indexPath.row][0].user.description
        
        let str = tweets[indexPath.row][0].created.description
        let start = str.index(str.startIndex, offsetBy: 11)
        let end = str.index(str.endIndex, offsetBy: -9)
        let range = start..<end
        
        // 3. date
        cell.tweetDate.text = String(tweets[indexPath.row][0].created.description[range])
        
        let attribString = NSMutableAttributedString(string: tweets[indexPath.row][0].text)
        
        // 4. tweet content
        
        // color to green: mentions
        if tweets[indexPath.row][0].userMentions.first?.keyword != nil  {
            for i in 0..<tweets[indexPath.row][0].userMentions.count {
                attribString.addAttribute(.foregroundColor, value: UIColor.green, range: tweets[indexPath.row][0].userMentions[i].nsrange)
            }
        }
        
        // color to red: urls
        if tweets[indexPath.row][0].urls.first?.keyword != nil  {
            for i in 0..<tweets[indexPath.row][0].urls.count {
                attribString.addAttribute(.foregroundColor, value: UIColor.red, range: tweets[indexPath.row][0].urls[i].nsrange)
            }
        }
        
        // color to blue: hashtags
        if tweets[indexPath.row][0].hashtags.first?.keyword != nil  {
            for i in 0..<tweets[indexPath.row][0].hashtags.count {
                attribString.addAttribute(.foregroundColor, value: UIColor.blue, range: tweets[indexPath.row][0].hashtags[i].nsrange)
            }
        }
        
        // now all set, assign the text
        cell.tweetText.attributedText = attribString
        
        return cell
    }
    
    
    // MARK: - Preparing for segue

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let indexPath = self.tableView.indexPath(for: sender as! UITableViewCell)
        
        if segue.identifier == "TweetSegue" {
            let destVC = segue.destination as! MentionsTVC
        
            if indexPath != nil {
                let index = indexPath!.row
                destVC.navTitle = tweets[index][0].user.screenName.description
                
                //Images
                if tweets[index][0].media.count > 0 {
                    destVC.data["Images"] = []
                    for i in 0..<tweets[index][0].media.count {
                        destVC.data["Images"]?.append(tweets[index][0].media[i].url)
                    }
                }
                
                // URLs
                if tweets[index][0].urls.count > 0 {
                    destVC.data["URLs"] = []
                    for i in 0..<tweets[index][0].urls.count {
                        destVC.data["URLs"]?.append(tweets[index][0].urls[i].keyword)
                    }
                }
                
                // Hashtags
                if tweets[index][0].hashtags.count > 0 {
                    destVC.data["Hashtags"] = []
                    for i in 0..<tweets[index][0].hashtags.count {
                        destVC.data["Hashtags"]?.append(tweets[index][0].hashtags[i].keyword)
                    }
                }
                
                // Users
                if tweets[index][0].userMentions.count > 0 {
                    destVC.data["Users"] = []
                    for i in 0..<tweets[index][0].userMentions.count {
                        destVC.data["Users"]?.append(tweets[index][0].userMentions[i].keyword)
                    }
                }
            }
        }
    }
    
    
    @IBAction func unwindFromMentionsTVC(_ segue: UIStoryboardSegue) {
//        refresh()
    }

}


    // MARK: - UITextFieldDelegate
extension TweetsTVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if let newQuery = textField.text {
            twitterQueryText = newQuery
            self.tableView.reloadData()
            refresh()
        }
        return true
    }
}
