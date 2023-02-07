//
//  MentionsTVC.swift
//  TweeterTags
//
//  Created by ActualChilli on 2022/11/28.
//

import UIKit

class MentionsTVC: UITableViewController {
    
    var data:[String: [Any]] = [:]
    var navTitle: String? 

    override func viewDidLoad() {
    
        super.viewDidLoad()
        self.title = navTitle
    }

    // MARK: - Table view datasource

    override func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        return data[Array(data.keys)[section]]!.count
    }

   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MentionsCell", for: indexPath) as! MentionsCustomCell

        // Configure the cell...
        
        // If it's an image, display the image, otherwise just convert to string
        if Array(data.keys)[indexPath.section] == "Images" {
            let data = try? Data(contentsOf: data[Array(data.keys)[indexPath.section]]![indexPath.row] as! URL)
            if let imageData = data {
                let image = UIImage(data: imageData)
                // hide text label when it's an image
                cell.mentionText.isHidden = true
                // delete the whitespaces
                cell.mentionPic!.widthAnchor.constraint(equalTo: cell.mentionPic!.heightAnchor, multiplier: image!.size.width / image!.size.height).isActive = true
                cell.mentionPic?.image = image
                
            }
        }else{
            cell.mentionText.text = (data[Array(data.keys)[indexPath.section]]![indexPath.row] as! String)
        }
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Array(data.keys)[section]
    }
    
    
    // MARK: - Segue

    // For urls and images: not going back to tweetTVC
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        switch Array(data.keys)[indexPath.section] {
        // open safari if it's an url
        case "URLs":
            let url = data["URLs"]![indexPath.row] as! String
                        UIApplication.shared.open(URL(string: url)!)
        // segue to ImageVC if it's an image
        case "Images":
            let cell = self.tableView.cellForRow(at: indexPath)
            self.performSegue(withIdentifier: "ImageSegue", sender: cell)
        default:
            
            break
        }
    }
    

    // If clicking users or hashtags, perform segue back to tweetTVC, otherwise open safari or segue to imageVC as above
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        let indexPath = self.tableView.indexPath(for: sender as! UITableViewCell)

        if identifier == "BTTweetSegue" {
            switch Array(data.keys)[indexPath!.section] {
            case "URLs", "Images":
                return false
            default:
                return true
            }
        }
        
        return true

    }

    // preparing data 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destVC = segue.destination as? TweetsTVC {
            let indexPath = self.tableView.indexPath(for: sender as! UITableViewCell)
            destVC.twitterQueryText = (data[Array(data.keys)[indexPath!.section]]![indexPath!.row] as! String)
        } else if let destVC = segue.destination as? ImageVC {
            let indexPath = self.tableView.indexPath(for: sender as! UITableViewCell)
            
            
            let data = try? Data(contentsOf: data[Array(data.keys)[indexPath!.section]]![indexPath!.row] as! URL)
            if let imageData = data {
                
                let image = UIImage(data: imageData)
                destVC.image = image
            }           
        }
    }
}
