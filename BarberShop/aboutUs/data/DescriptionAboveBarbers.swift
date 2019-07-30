//
//  DescriptionAboveBarbers.swift
//  BarberShop
//
//  Created by Daniel Radshun on 18/06/2019.
//  Copyright © 2019 Neighbors. All rights reserved.
//

import Foundation

class DescriptionAboveBarbers:DictionaryConvertible {
    
    static var shared:DescriptionAboveBarbers?
    
    var descriptionText:String
    
    init(descriptionText:String) {
        self.descriptionText = descriptionText
    }
    
    static func fetchData(){
        DAO.shared.readDescriptionAboveBarbers { (descriptionAboveBarbers) in
            DescriptionAboveBarbers.shared = descriptionAboveBarbers
        }
    }
    
    // DictionaryConvertible protocol methods
    required convenience init?(dict: NSDictionary) {
        guard let descriptionText = dict["descriptionText"] as? String
            else {
                return nil
        }
        
        self.init(descriptionText: descriptionText)
    }
    
    var dict:NSDictionary {
        return NSDictionary(dictionary: ["descriptionText":descriptionText])
    }
}
