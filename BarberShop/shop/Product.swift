//
//  Product.swift
//  BarberShop
//
//  Created by Daniel Fraimovich on 16/07/2019.
//  Copyright © 2019 Neighbors. All rights reserved.
//

import Foundation

class Product:DictionaryConvertible{
    let name:String
    let price:String
    let details:String
    let imagePath:String
    
    init(name:String, price:String, details:String, imagePath: String) {
        self.name = name
        self.price = price
        self.details = details
        self.imagePath = imagePath
    }
    
    
    var realPrice:String{
        return "\(price)₪"
    }
    
    
    required convenience init?(dict: NSDictionary) {
        guard let name = dict["name"] as? String ,
        let price = dict["price"] as? String,
        let details = dict["details"] as? String,
            let imagePath = dict["imagePath"] as? String else {return nil}
        
        self.init(name: name, price: price, details: details, imagePath: imagePath)
        
    }
    var dict: NSDictionary{
        return[
            "name":name,
            "price":price,
            "details":details,
            "imagePath":imagePath
        ]
    }
}
