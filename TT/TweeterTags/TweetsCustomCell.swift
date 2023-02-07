//
//  TableViewCell.swift
//  TweeterTags
//
//  Created by ActualChilli on 2022/11/23.
//

import UIKit

class TweetsCustomCell: UITableViewCell {
    
    
    @IBOutlet weak var tweetAvatar: UIImageView!
    @IBOutlet weak var tweeterScreenName: UILabel!
    @IBOutlet weak var tweetDate: UILabel!
    @IBOutlet weak var tweetText: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
