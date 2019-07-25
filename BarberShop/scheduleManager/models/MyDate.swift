//
//  Date.swift
//  BarberShop
//
//  Created by Daniel Radshun on 14/07/2019.
//  Copyright © 2019 Neighbors. All rights reserved.
//

import Foundation

class MyDate:CustomStringConvertible, Equatable, DictionaryConvertible {
    var day:Int
    var month:Int
    var year:Int
    
    init(day:Int, month:Int, year:Int) {
        self.day = day
        self.month = month
        self.year = year
    }
    
    var description:String{
        return "\(day).\(month)"
    }
    
    //comparing func
    public static func ==(lhs: MyDate, rhs: MyDate) -> Bool{
        return
            lhs.day == rhs.day &&
                lhs.month == rhs.month &&
                lhs.year == rhs.year
    }
    
    public static func <(lhs: MyDate, rhs: MyDate) -> Bool{
        return
            lhs.month == rhs.month &&
                lhs.day < rhs.day ||
            lhs.month < rhs.month
    }
    
    //-----------------------
    //remove after site is on
    func generateId() -> Int{
        var monthId = ""
        if month < 10{
            monthId = "0\(month)"
        }
        else{
            monthId = "\(month)"
        }
        return Int("\(day)\(monthId)\(year)") ?? -1
    }
    
    // DictionaryConvertible protocol methods
    required convenience init?(dict: NSDictionary) {
        guard let day = dict["day"] as? Int,
            let month = dict["month"] as? Int,
            let year = dict["year"] as? Int
            else {
                return nil
        }
        
        self.init(day: day, month: month, year: year)
    }
    
    var dict:NSDictionary {
        return NSDictionary(dictionary: ["day":day,
                                         "month": month,
                                         "year":year])
    }
}
