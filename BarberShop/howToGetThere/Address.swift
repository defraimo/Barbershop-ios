//
//  Adress.swift
//  BarberShop
//
//  Created by Daniel Fraimovich on 06/07/2019.
//  Copyright © 2019 Neighbors. All rights reserved.
//

import UIKit
import CoreLocation

class Address:CustomStringConvertible , DictionaryConvertible{
    let streetNum:String
    let streetName:String
    let city:String
    let shopName: String
    
    init(streetNum:String ,streetName:String ,city:String ,shopName:String) {
        self.streetNum = streetNum
        self.streetName = streetName
        self.city = city
        self.shopName = shopName
    }
    required convenience init?(dict: NSDictionary) {
        guard let streetNum = dict["streetNum"] as? String,
        let streetName = dict["streetName"] as? String,
        let city = dict["city"] as? String,
        let shopName = dict["shopName"] as? String
        else {return nil}
        
        self.init(streetNum: streetNum ,streetName: streetName ,city: city ,shopName: shopName)
    }
    
    var dict: NSDictionary{
        return [
            "streetNum": streetNum,
            "streetName": streetName,
            "city": city,
            "shopName": shopName
        ]
    }
    var description:String{
        return "\(streetName) \(streetNum), \(city)"
    }
    

    func addressToCLLocation(completion: @escaping (_ location:CLLocation) -> Void) {
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(description) { (placemarks, error) in
            guard let placemarks = placemarks,
                let location = placemarks.first?.location
                else {
                    print(error)
                    return
            }
            completion(location)
        }
    }
}
