//
//  PricesDataSource.swift
//  BarberShop
//
//  Created by Daniel Radshun on 17/06/2019.
//  Copyright © 2019 Neighbors. All rights reserved.
//

import Foundation

class PricesDataSource{
    var pricesList:[PriceModel]{
        return [PriceModel(servies: "תספורת", price: "40₪"),
                PriceModel(servies: "תספורת ילדים", price: "35₪"),
                PriceModel(servies: "תספורת + זקן", price: "50₪"),
                PriceModel(servies: "צבע", price: "80₪"),
                PriceModel(servies: "תספורת + צבע", price: "110₪"),
                PriceModel(servies: "גוונים", price: "70₪"),
                PriceModel(servies: "תספורת + גוונים", price: "100₪")]
    }
}
