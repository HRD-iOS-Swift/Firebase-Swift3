//
//  User.swift
//  FirebaseAppDemo
//
//  Created by Frezy Stone Mboumba on 10/2/16.
//  Copyright © 2016 MaranathApp. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase


struct User {
    
    var username: String!
    var email: String?
    var country: String?
    var photoURL: String!
    var biography: String?
    var uid: String!
    var ref: FIRDatabaseReference?
    var key: String?
    var firstLastName: String!
    
    init(snapshot: FIRDataSnapshot){
        
        key = snapshot.key
        ref = snapshot.ref
        username = (snapshot.value! as! NSDictionary)["username"] as! String
        email = (snapshot.value! as! NSDictionary)["email"] as? String
        country = (snapshot.value! as! NSDictionary)["country"] as? String
        uid = (snapshot.value! as! NSDictionary)["uid"] as! String
        biography = (snapshot.value! as! NSDictionary)["biography"] as? String
        photoURL = (snapshot.value! as! NSDictionary)["photoURL"] as! String
        firstLastName = (snapshot.value! as! NSDictionary)["firstLastName"] as! String

    }
    
    
//    func toAnyObject() -> [String: Any] {
//        return ["email"]
//    }
    
}
