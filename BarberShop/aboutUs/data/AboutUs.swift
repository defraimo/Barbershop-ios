//
//  AboutUs.swift
//  BarberShop
//
//  Created by Daniel Radshun on 18/06/2019.
//  Copyright © 2019 Neighbors. All rights reserved.
//

import Foundation

class AboutUs:DictionaryConvertible {
    var title:String
    var text:String
    
    static var shared:AboutUs?
    
    init(title:String, text:String) {
        self.title = title
        self.text = text
    }
    
    static func fetchData(){
        DAO.shared.readAboutUs(complition: { (aboutUs) in
            AboutUs.shared = aboutUs
        })
    }
    
    // DictionaryConvertible protocol methods
    required convenience init?(dict: NSDictionary) {
        guard let title = dict["title"] as? String,
            let text = dict["text"] as? String
            else {
                return nil
        }
        
        self.init(title: title, text: text)
    }
    
    var dict:NSDictionary {
        return NSDictionary(dictionary: ["title":title,
                                         "text": text])
    }
}
