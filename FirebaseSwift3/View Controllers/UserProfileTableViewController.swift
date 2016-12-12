//
//  UserProfileTableViewController.swift
//  MaranathApp
//
//  Created by Frezy Stone Mboumba on 8/12/16.
//  Copyright © 2016 Frezy Stone Mboumba. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth

struct StretchyHeader {
    let headerHeight: CGFloat = 355
    let headerCut: CGFloat = 50
}

class UserProfileTableViewController: UITableViewController {
    
    @IBOutlet weak var userBiographyTextView: UITextView!
    @IBOutlet weak var userCountry: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var firstLastNameLabel: UILabel!
    
    var headerView: UIView!
    var newHeaderLayer: CAShapeLayer!
    
    // ##1 - Create property
    var dataBaseRef: FIRDatabaseReference! {
        return FIRDatabase.database().reference()
    }
    
    var storageRef: FIRStorage {
        return FIRStorage.storage()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userImageView.layer.cornerRadius = 65
        updateView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        // ##2 - Load User
        loadUserInfo()
    }
    
    
    @IBAction func unwindToProfile(storyboard: UIStoryboardSegue){}
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        return cell
    }
}

//-------------------------------------------------------------------------------------------------------
// MARK: - Load User and Log out
extension UserProfileTableViewController{
    // ##2 - Load User
    func loadUserInfo(){
        
        let userRef = dataBaseRef.child("users/\(FIRAuth.auth()!.currentUser!.uid)")
        userRef.observe(.value, with: { (snapshot) in
            
            let user = User(snapshot: snapshot)
            self.usernameLabel.text = "@" + user.username
            self.userCountry.text = user.country!
            self.userBiographyTextView.text = user.biography!
            self.firstLastNameLabel.text = user.firstLastName
            let imageURL = user.photoURL!
            
            self.storageRef.reference(forURL: imageURL).data(withMaxSize: 1 * 1024 * 1024, completion: { (imgData, error) in
                
                if error == nil {
                    DispatchQueue.main.async {
                        if let data = imgData {
                            self.userImageView.image = UIImage(data: data)
                        }
                    }
                }else {
                    print(error!.localizedDescription)
                    
                }
            })
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    // ##3 - Log Out
    @IBAction func logOutAction(sender: AnyObject) {
        
        if FIRAuth.auth()!.currentUser != nil {
            // there is a user signed in
            do {
                try? FIRAuth.auth()!.signOut()
                
                if FIRAuth.auth()?.currentUser == nil {
                    let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Login") as! LoginViewController
                    self.present(loginVC, animated: true, completion: nil)
                }
                
            }
        }
    }

}

extension UserProfileTableViewController {
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        setNewView()
    }
    
    func updateView(){
        
        tableView.backgroundColor = UIColor.white
        headerView = tableView.tableHeaderView
        tableView.tableHeaderView = nil
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.addSubview(headerView)
        
        newHeaderLayer = CAShapeLayer()
        newHeaderLayer.fillColor = UIColor.black.cgColor
        headerView.layer.mask = newHeaderLayer
        
        let newHeight = StretchyHeader().headerHeight - StretchyHeader().headerCut/2
        
        tableView.contentInset = UIEdgeInsets(top: newHeight, left: 0, bottom: 0, right: 0)
        tableView.contentOffset = CGPoint(x: 0, y: -newHeight)
        setNewView()
    }
    
    
    func setNewView(){
        
        let newHeight = StretchyHeader().headerHeight - StretchyHeader().headerCut/2
        var getHeaderFrame =  CGRect(x: 0, y: -newHeight, width: tableView.bounds.width, height: StretchyHeader().headerHeight)
        
        if tableView.contentOffset.y < newHeight {
            
            getHeaderFrame.origin.y = tableView.contentOffset.y
            getHeaderFrame.size.height = -tableView.contentOffset.y + StretchyHeader().headerCut/2
        }
        
        headerView.frame = getHeaderFrame
        let cutDirection = UIBezierPath()
        cutDirection.move(to: CGPoint(x: 0, y: 0))
        cutDirection.addLine(to: CGPoint(x: getHeaderFrame.width, y: 0))
        cutDirection.addLine(to: CGPoint(x: getHeaderFrame.width, y: getHeaderFrame.height))
        cutDirection.addLine(to: CGPoint(x: 0, y: getHeaderFrame.height - StretchyHeader().headerCut))
        newHeaderLayer.path = cutDirection.cgPath

    }
    
}
