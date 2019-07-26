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
    var clientId:String? //TO CHANGE!!!!!!
    var date:MyDate?
    var units:[TimeUnit]?
    var servies:PriceModel?
    
    //empty init so we could set all the params by steps
    init() {}
    
    private init(barber:Barber?, clientId:String?, date:MyDate?, units:[TimeUnit]?, servies:PriceModel?) {
        self.barber = barber
        self.clientId = clientId
        self.date = date
        self.units = units
        self.servies = servies
    }
    
    var description: String{
        return "\(String(describing: barber?.name)), \(String(describing: clientId)), \(String(describing: date?.description)), \(String(describing: units?.description)), \(String(describing: servies?.servies)) \(String(describing: servies?.priceRange))"
    }
    
    
    // DictionaryConvertible protocol methods
    required convenience init?(dict: NSDictionary) {
        
        var barber:Barber?
        if let barberDict = dict["barber"] as? NSDictionary{
            barber = Barber(dict: barberDict)
        }
        
        var clientId:String? // TO CHANGE!!!!!!!!!!!!
        if let clientDict = dict["clientId"] as? String{
            clientId = clientDict
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
        
        self.init(barber: barber, clientId: clientId, date: date, units: units, servies: servies)
    }
    
    var dict:NSDictionary {
        var dictionary:[String:Any] = [:]
        
        if self.barber != nil{
            dictionary["barber"] = barber?.dict
        }
        
        if self.clientId != nil{
            dictionary["clientId"] = clientId // TO CHANGE!!!!!!!!!!!!
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
