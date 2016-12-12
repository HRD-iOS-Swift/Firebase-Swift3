//
//  FeedTableViewController.swift
//  FirebaseAppDemo
//
//  Created by Frezy Stone Mboumba on 9/20/16.
//  Copyright © 2016 MaranathApp. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth
import FirebaseRemoteConfig

class FeedTableViewController: UITableViewController {
    
    var postArray = [Post]()
    
    var dataBaseRef: FIRDatabaseReference! {
        return FIRDatabase.database().reference()
    }
    
    var remoteConfig : FIRRemoteConfig!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        remoteConfig = FIRRemoteConfig.remoteConfig()
        let remoteConfigSettings = FIRRemoteConfigSettings(developerModeEnabled: true)
        remoteConfig.configSettings = remoteConfigSettings!
        setupRemoteConfig()
        fetchRemoteConfig()
        
        
    }
    
    func setupRemoteConfig() {
        let defaultValue = [
            "navTitle":"Hello"
        ]
        remoteConfig.setDefaults(defaultValue as [String : NSObject]?)
        
    }
    
    func fetchRemoteConfig() {
        // 1
        // WARNING: Don't actually do this in production!
        var expirationDuration = 3600
        if remoteConfig.configSettings.isDeveloperModeEnabled {
            expirationDuration = 0
        }
        
        remoteConfig.fetch(withExpirationDuration: TimeInterval(expirationDuration)) { (status, error) -> Void in
            if status == .success {
                print("Config fetched!")
                self.remoteConfig.activateFetched()
            } else {
                print("Config not fetched")
                print("Error \(error!.localizedDescription)")
            }
            self.updateView()
        }
    }
    
    func updateView() {
        let rc = remoteConfig!
        //rc.configValue(forKey: "navTitle")
        //rc.configValue(forKey: "navTitle").stringValue
        //rc["navTitle"]
        self.title = rc["navTitle"].stringValue
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        fetchPosts()
    }
    
    func fetchPosts(){
        print("\(dataBaseRef.child("posts"))")
        dataBaseRef.child("posts").observe(.value, with: { (snapshot) in
            var results = [Post]()
            
            for post in snapshot.children {
                
                let post = Post(snapshot: post as! FIRDataSnapshot)
                results.append(post)
            }
            self.postArray = results
            self.tableView.reloadData()
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
}

//-------------------------------------------------------------------------------------------------------
// MARK: - TableView Delegate and DataSource
extension FeedTableViewController{
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if postArray[indexPath.row].postPicUrl != "" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "imageCell", for: indexPath) as! FeedOneTableViewCell
            
            cell.configureCell(post: postArray[indexPath.row])
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "textCell", for: indexPath) as! FeedTwoTableViewCell
            cell.configureCell(post: postArray[indexPath.row])
            return cell
        }
    }
}
