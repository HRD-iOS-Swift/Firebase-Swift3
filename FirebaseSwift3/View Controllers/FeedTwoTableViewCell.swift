//
//  FeedTwoTableViewCell.swift
//  FirebaseSwift3
//
//  Created by Kokpheng on 12/9/16.
//  Copyright © 2016 Kokpheng. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth

class FeedTwoTableViewCell: UITableViewCell {
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var postDateLabel: UILabel!
    
    @IBOutlet weak var firstLastNameLabel: UILabel!
    
    @IBOutlet weak var postTextTextView: UITextView!
    
    var dataBaseRef: FIRDatabaseReference! {
        return FIRDatabase.database().reference()
    }
    
    var storageRef: FIRStorage {
        
        return FIRStorage.storage()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(post: Post){
        self.usernameLabel.text = post.username
        self.postDateLabel.text = "\(post.postDate)"
        self.firstLastNameLabel.text = post.firstLastName
        self.postTextTextView.text = post.postText
    
        let profileURL = post.postPicUrl!
        
    }

}
