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
    
    var pricesList:[PriceModel]?
    
    func fetchPrices(){
        DAO.shared.loadPrices { (prices) in
            self.pricesList = prices.sorted(by: { $0.id < $1.id })
            print("Prices were loaded")
        }
    }
    
}
