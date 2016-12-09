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

class FeedTableViewController: UITableViewController {

    
    var postArray = [Post]()
    
    var dataBaseRef: FIRDatabaseReference! {
        return FIRDatabase.database().reference()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
