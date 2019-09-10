//
//  AdressAnotation.swift
//  BarberShop
//
//  Created by Daniel Fraimovich on 06/07/2019.
//  Copyright © 2019 Neighbors. All rights reserved.
//

import MapKit

class AddressAnotation: NSObject, MKAnnotation{
    var coordinate: CLLocationCoordinate2D
    //title
    var title:String?
    //subtitle:
    var subtitle:String?
    
    
    init(title:String? , subtitle:String?, coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
    }
    
    
    
}
