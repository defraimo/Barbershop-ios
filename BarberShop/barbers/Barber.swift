//
//  Barber.swift
//  BarberShop
//
//  Created by Daniel Radshun on 18/06/2019.
//  Copyright © 2019 Neighbors. All rights reserved.
//

import UIKit

class Barber:DictionaryConvertible, Equatable, Codable{
    var name:String
    var id:Int
    var description:String?
    var image:UIImage?
    var imagePath:String?
    
    private enum CodingKeys: String, CodingKey {
        case name
        case id
        case description
        case imagePath
    }
    
    init(name:String, id:Int, description:String?, image:UIImage?, imagePath:String?) {
        self.name = name
        self.id = id
        self.description = description
        self.image = image
        self.imagePath = imagePath
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decode(String.self, forKey: .name)
        id = try values.decode(Int.self, forKey: .id)
        description = try? values.decode(String.self, forKey: .description)
        image = nil
        imagePath = try? values.decode(String.self, forKey: .imagePath)
    }
    
    // DictionaryConvertible protocol methods
    required convenience init?(dict: NSDictionary) {
        guard let name = dict["name"] as? String, let id = dict["id"] as? Int else {
            return nil
        }
//        let image = dict["image"] as? UIImage ?? nil
        let description = dict["description"] as? String ?? nil
        let imagePath = dict["imagePath"] as? String ?? nil
        
        self.init(name: name, id: id, description: description, image: nil, imagePath: imagePath)
    }
    
    var dict:NSDictionary {
        var dictionary:[String:Any] = ["name": name,
                                       "id":id]
        if self.description != ""{
            dictionary["description"] = description
        }
        if self.imagePath != nil{
            dictionary["imagePath"] = imagePath
        }
        
        return NSDictionary(dictionary: dictionary)
    }
    
    static func == (lhs: Barber, rhs: Barber) -> Bool {
        return lhs.name == rhs.name && lhs.id == rhs.id && lhs.description == rhs.description && lhs.imagePath == rhs.imagePath
    }
}
