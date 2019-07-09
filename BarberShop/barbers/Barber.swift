//
//  Barber.swift
//  BarberShop
//
//  Created by Daniel Radshun on 18/06/2019.
//  Copyright © 2019 Neighbors. All rights reserved.
//

import UIKit

struct Barber {
    var name:String
    var description:String?
    var image:UIImage
    var schedule:DatesManager?
    var daysSchedule:[Day]?
}
