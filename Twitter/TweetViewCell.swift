//
//  TweetViewCell.swift
//  Twitter
//
//  Created by Abylbek Khassenov on 12/2/20.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class TweetViewCell: UITableViewCell {

    @IBOutlet weak var hashtagLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var dateLabe: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }


}
