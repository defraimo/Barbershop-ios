//
//  PriceModel.swift
//  BarberShop
//
//  Created by Daniel Radshun on 17/06/2019.
//  Copyright © 2019 Neighbors. All rights reserved.
//

import Foundation

class PriceModel:DictionaryConvertible {
    var id:Int
    var servies:String
    var priceRange:PriceRange
    var duration:Int?
    var barbers:[Barber]
    
    init(id:Int, servies:String, priceRange:PriceRange, duration:Int?, barbersIndex:[Int]?) {
        self.id = id
        self.servies = servies
        self.priceRange = priceRange
        self.duration = duration
        if barbersIndex != nil{
            self.barbers = AllBarbers.shared.getBarbersByIndex(barbersIndex!)
        }
        else{
            self.barbers = AllBarbers.shared.allBarbers
        }
    }
    
    // DictionaryConvertible protocol methods
    required convenience init?(dict: NSDictionary) {
        guard let id = dict["id"] as? Int,
            let servies = dict["servies"] as? String,
            let priceRangeDict = dict["priceRange"] as? NSDictionary,
            let barbersIndex = dict["barbersIndex"] as? [Int]
        else {
            return nil
        }
        let duration = dict["duration"] as? Int ?? nil
        
        guard let priceRange = PriceRange(dict: priceRangeDict) else {return nil}
        
        self.init(id: id, servies: servies, priceRange: priceRange, duration: duration, barbersIndex: barbersIndex)
    }
    
    var dict:NSDictionary {
        var barbersDict:[Int] = []
        for barber in barbers{
            barbersDict.append(barber.id)
        }
        
        var dictionary:[String:Any] = ["id":id,
                                       "servies": servies,
                                       "priceRange":priceRange.dict,
                                       "barbersIndex":barbersDict]
        
        if self.duration != nil{
            dictionary["duration"] = duration
        }
        
        return NSDictionary(dictionary: dictionary)
    }
}

class PriceRange:CustomStringConvertible,DictionaryConvertible {
    var lowestPrice:Int
    var heighestPrice:Int?
    
    var description: String{
        if heighestPrice != nil{
            return "\(lowestPrice)₪ - \(heighestPrice!)₪"
        }
        else{
            return "\(lowestPrice)₪"
        }
    }
    
    init(lowestPrice:Int, heighestPrice:Int?) {
        self.lowestPrice = lowestPrice
        self.heighestPrice = heighestPrice
    }
    
    // DictionaryConvertible protocol methods
    required convenience init?(dict: NSDictionary) {
        guard let lowestPrice = dict["lowestPrice"] as? Int
            else {
                return nil
        }
        
        let heighestPrice = dict["heighestPrice"] as? Int ?? nil
        
        self.init(lowestPrice: lowestPrice, heighestPrice: heighestPrice)
    }
    
    var dict:NSDictionary {
        var dictionary:[String:Any] = ["lowestPrice": lowestPrice]
        
        if self.heighestPrice != nil{
            dictionary["heighestPrice"] = heighestPrice
        }
        
        return NSDictionary(dictionary: dictionary)
    }
}
