//
//  User.swift
//  BarberShop
//
//  Created by Daniel Fraimovich on 29/06/2019.
//  Copyright © 2019 Neighbors. All rights reserved.
//

import Foundation

class User:DictionaryConvertible, CustomStringConvertible{
    let number:String
    let fullName:String
    //woman is 0, man is 1:
    let gender:Int
    let email:String?
    
     init(number:String, fullName:String,gender:Int, email:String?) {
        self.number = number
        self.fullName = fullName
        self.gender = gender
        self.email = email
    }
    // DictionaryConvertible protocol methods
    required convenience init?(dict: NSDictionary) {
        guard let number = dict["number"] as? String, let fullName = dict["fullName"] as? String, let gender = dict["gender"] as? Int else {
            return nil
        }
        let email = dict["email"] as? String ?? nil
        self.init(number: number, fullName: fullName, gender: gender, email: email)
    }
    
    var dict:NSDictionary {
        if self.email == ""{
            return [
                "number": number,
                "fullName":fullName,
                "gender": gender
            ]
        }
        return [
            "number": number,
            "fullName":fullName,
            "gender": gender,
            "email": email
        ]
    }
    
    var description: String{
        if gender == 0{
            return "\(fullName), \(number), Female"
        }else if gender == 1{
            return "\(fullName), \(number), Male"
        }
        return "\(fullName), \(number)"
    }
}
