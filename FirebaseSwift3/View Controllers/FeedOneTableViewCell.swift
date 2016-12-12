//
//  FeedOneTableViewCell.swift
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

class FeedOneTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var postDateLabel: UILabel!
    
    @IBOutlet weak var firstLastNameLabel: UILabel!
    
    @IBOutlet weak var postImageView: UIImageView!
    
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
        
        let date = Date(timeIntervalSince1970: post.postDate as TimeInterval)
        self.usernameLabel.text = post.username
        self.postDateLabel.text = "\(date)"
        self.firstLastNameLabel.text = post.firstLastName
        self.postTextTextView.text = post.postText
      
        let postURL = post.postPicUrl!
        print(postURL)
        self.storageRef.reference(forURL: postURL).data(withMaxSize: 1 * 1024 * 1024, completion: { (imgData, error) in
            
            if error == nil {
                DispatchQueue.main.async {
                    if let data = imgData {
                        self.postImageView.image = UIImage(data: data)
                    }
                }
            }else {
                print(error!.localizedDescription)
                
            }
        })
        
        self.storageRef.reference().child("profileImage/\(post.uid!)/userPic.jpg").data(withMaxSize:  1 * 1024 * 1024, completion: { (imgData, error) in
            
            if error == nil {
                DispatchQueue.main.async {
                    if let data = imgData {
                        self.profileImageView.image = UIImage(data: data)
                    }
                }
            }else {
                print(error!.localizedDescription)
                
            }
        })
    }

}
