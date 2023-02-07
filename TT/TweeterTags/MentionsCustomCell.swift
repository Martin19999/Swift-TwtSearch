//
//  MentionsCustomCell.swift
//  TweeterTags
//
//  Created by ActualChilli on 2022/11/29.
//

import UIKit

class MentionsCustomCell: UITableViewCell {
    
    

    @IBOutlet weak var mentionText: UILabel!
    @IBOutlet weak var mentionPic: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
