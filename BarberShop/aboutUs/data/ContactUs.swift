//
//  ContactUs.swift
//  BarberShop
//
//  Created by Daniel Radshun on 18/06/2019.
//  Copyright © 2019 Neighbors. All rights reserved.
//

import Foundation

class ContactUs:DictionaryConvertible {
    var phone:String?
    var email:String?
    var instagramName:String?
    
    static var shared:ContactUs?
    
    init(phone:String, email:String, instagramName:String?) {
        self.phone = phone
        self.email = email
        self.instagramName = instagramName
    }
    
    static func fetchData(){
        DAO.shared.readContactUs { (contactUs) in
            ContactUs.shared = contactUs
        }
    }
    
    var whatsupp:String{
        let number = phone!.replacingOccurrences(of: "0", with: "+972")
        return(number)
    }
    
    var displayedPhone:String{
        var number = phone!
        number.insert("-", at: number.index(number.startIndex, offsetBy: 3))
        return(number)
    }
    
    // DictionaryConvertible protocol methods
    required convenience init?(dict: NSDictionary) {
        guard let phone = dict["phone"] as? String,
            let email = dict["email"] as? String
            else {
                return nil
        }
        
        let instagramName = dict["instagramName"] as? String ?? nil
        
        self.init(phone: phone, email: email, instagramName: instagramName)
    }
    
    var dict:NSDictionary {
        var dictionary = ["phone":phone,
                          "email":email]
        
        if instagramName != nil{
            dictionary["instagramName"] = instagramName!
        }
        
        return NSDictionary(dictionary: dictionary as [AnyHashable : Any])
    }
}

