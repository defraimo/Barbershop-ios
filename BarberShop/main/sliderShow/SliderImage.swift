//
//  SliderImage.swift
//  BarberShop
//
//  Created by Daniel Radshun on 01/08/2019.
//  Copyright © 2019 Neighbors. All rights reserved.
//

import Foundation

class SliderImage:DictionaryConvertible{
    var index:Int
    var imagePath:String
    
    init(index:Int, imagePath:String) {
        self.index = index
        self.imagePath = imagePath
    }
    
    // DictionaryConvertible protocol methods
    required convenience init?(dict: NSDictionary) {
        guard let index = dict["index"] as? Int,
            let imagePath = dict["imagePath"] as? String
            else {
                return nil
        }
        
        self.init(index: index, imagePath: imagePath)
    }
    
    var dict:NSDictionary {
        return NSDictionary(dictionary: ["index":index,
                                         "imagePath": imagePath])
    }
}
