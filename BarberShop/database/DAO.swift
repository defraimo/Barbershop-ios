//
//  DAO.swift
//  BarberShop
//
//  Created by Daniel Fraimovich on 09/07/2019.
//  Copyright © 2019 Neighbors. All rights reserved.
//

import UIKit
import FirebaseDatabase

class DAO{
    static var shared = DAO()
    var ref:DatabaseReference!
    
    private init(){
        ref = Database.database().reference()
    }
    func saveNewUser(_ user: User){
    
    }
    func printUser(){
        ref.child("Users").child("4eXYAV9Bh7NJGevXGknwD7iKpEX2").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            guard let value = snapshot.value as? NSDictionary else {return}
            
            guard let name = value["fullName"] as? String,
                  let gender = value["gender"] as? Int,
                let number = value["number"] as? String else {print("shit");return}
            print(User(number: number, fullName: name, gender: gender, email: nil))
            
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
}
