//
//  BarbersSchedule.swift
//  BarberShop
//
//  Created by Daniel Radshun on 25/06/2019.
//  Copyright © 2019 Neighbors. All rights reserved.
//

import UIKit

class BarbersSchedule{
    var allBarbersShedule:[DatesManager] = []
    
    init() {
        for barber in AllBarbers().allBarbers{
            allBarbersShedule.append((barber.schedule ?? nil)!)
        }
    }
}


@IBDesignable
public class M: UIButton {
    
    @IBInspectable
    var radius: CGFloat = 10{
        didSet{
            
            self.layer.cornerRadius = radius
        }
    }
    
    @IBInspectable
    var radiusColor: UIColor = UIColor.black{
        didSet{
            
            self.layer.cornerRadius = radius
        }
    }
    
    
    @IBInspectable
    var borderWidth: CGFloat = 3{
        didSet{
              self.layer.borderWidth = borderWidth
        }
    }
   
}
