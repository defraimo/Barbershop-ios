//
//  Adress.swift
//  BarberShop
//
//  Created by Daniel Fraimovich on 06/07/2019.
//  Copyright © 2019 Neighbors. All rights reserved.
//

import UIKit
import CoreLocation

struct Address:CustomStringConvertible {
    let streetNum:String
    let streetName:String
    let city:String
    let shopName: String
    let latitude:Double
    let longitude:Double
    
    var location:CLLocation{
        return CLLocation(latitude: latitude, longitude: longitude)
    }
    var description:String{
        return "\(streetName) \(streetNum), \(city)"
    }
}
