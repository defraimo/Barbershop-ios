//
//  PricesDataSource.swift
//  BarberShop
//
//  Created by Daniel Radshun on 17/06/2019.
//  Copyright © 2019 Neighbors. All rights reserved.
//

import Foundation

class PricesDataSource{
    
    static let shared = PricesDataSource()
    
    var pricesList:[PriceModel]{
        return [PriceModel(servies: "תספורת", priceRange: PriceRange(lowestPrice: 40, heighestPrice: nil), barbers: nil),
                PriceModel(servies: "תספורת ילדים", priceRange: PriceRange(lowestPrice: 35, heighestPrice: nil), barbers: nil),
                PriceModel(servies: "תספורת + זקן", priceRange: PriceRange(lowestPrice: 50, heighestPrice: nil), barbers: [barbers[0],barbers[1],barbers[2]]),
                PriceModel(servies: "צבע", priceRange: PriceRange(lowestPrice: 80, heighestPrice: 100), barbers: [barbers[1],barbers[3]]),
                PriceModel(servies: "תספורת + צבע", priceRange: PriceRange(lowestPrice: 110, heighestPrice: 130), barbers: [barbers[1],barbers[3]]),
                PriceModel(servies: "גוונים", priceRange: PriceRange(lowestPrice: 70, heighestPrice: 80), barbers: nil),
                PriceModel(servies: "תספורת + גוונים", priceRange: PriceRange(lowestPrice: 90, heighestPrice: 110), barbers: [barbers[3]])]
    }
}
