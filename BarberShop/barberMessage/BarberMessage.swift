//
//  BarberMessage.swift
//  BarberShop
//
//  Created by Daniel Fraimovich on 05/08/2019.
//  Copyright © 2019 Neighbors. All rights reserved.
//

import Foundation

class BarberMessage{
    var message:String?
    
    static var shared:BarberMessage?
    
    private init(message:String?) {
        self.message = message
    }
    
    static func fetchData(){
        DAO.shared.checkMessageDialogue { (message) in
            shared = BarberMessage(message: message)
        }
    }
}
