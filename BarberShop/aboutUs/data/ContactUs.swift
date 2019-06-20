//
//  ContactUs.swift
//  BarberShop
//
//  Created by Daniel Radshun on 18/06/2019.
//  Copyright © 2019 Neighbors. All rights reserved.
//

import Foundation

struct ContactUs {
    var phone:String = "054-4533616"
    var email:String = "neighbors.apps@gmail.com"
    
    var contactDetails:[String]{
        return [phone,email]
    }
}

