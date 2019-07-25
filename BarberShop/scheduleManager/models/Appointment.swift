//
//  Appointment.swift
//  BarberShop
//
//  Created by Daniel Radshun on 23/06/2019.
//  Copyright © 2019 Neighbors. All rights reserved.
//

import Foundation

class Appointment:CustomStringConvertible {
    var barber:Barber?
    var client:String? //TO CHANGE!!!!!!
    var date:MyDate?
    var units:[TimeUnit]?
    var servies:PriceModel?
    
    //empty init so we could set all the params by steps
    init() {}
    
    private init(barber:Barber?, client:String?, date:MyDate?, units:[TimeUnit]?, servies:PriceModel?) {
        self.barber = barber
        self.client = client
        self.date = date
        self.units = units
        self.servies = servies
    }
    
    var description: String{
        return "\(String(describing: barber?.name)), \(String(describing: client)), \(String(describing: date?.description)), \(String(describing: units?.description)), \(String(describing: servies?.servies)) \(String(describing: servies?.priceRange))"
    }
    
    
    // DictionaryConvertible protocol methods
    required convenience init?(dict: NSDictionary) {
        
        var barber:Barber?
        if let barberDict = dict["barber"] as? NSDictionary{
            barber = Barber(dict: barberDict)
        }
        
        var client:String? // TO CHANGE!!!!!!!!!!!!
        if let clientDict = dict["client"] as? String{
            client = clientDict
        }
        
        var date:MyDate?
        if let dateDict = dict["date"] as? NSDictionary{
            date = MyDate(dict: dateDict)
        }
        
        var units:[TimeUnit]?
        if let unitsDictArray = dict["units"] as? [NSDictionary]{
            units = []
            for unitDict in unitsDictArray{
                units?.append(TimeUnit(dict: unitDict)!)
            }
        }
        
        var servies:PriceModel?
        if let serviesDict = dict["servies"] as? NSDictionary{
            servies = PriceModel(dict: serviesDict)
        }
        
        self.init(barber: barber, client: client, date: date, units: units, servies: servies)
    }
    
    var dict:NSDictionary {
        var dictionary:[String:Any] = [:]
        
        if self.barber != nil{
            dictionary["barber"] = barber?.dict
        }
        
        if self.client != nil{
            dictionary["client"] = client // TO CHANGE!!!!!!!!!!!!
        }
        
        if self.date != nil{
            dictionary["date"] = date?.dict
        }
        
        if self.units != nil{
            var unitsDict:[NSDictionary] = []
            for unit in units!{
                unitsDict.append(unit.dict)
            }
            dictionary["units"] = unitsDict
        }
        
        if self.servies != nil{
            dictionary["servies"] = servies?.dict
        }
        
        return NSDictionary(dictionary: dictionary)
    }
 
}
