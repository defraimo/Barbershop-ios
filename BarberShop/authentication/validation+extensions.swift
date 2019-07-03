//
//  validation+extensions.swift
//  BarberShop
//
//  Created by Daniel Fraimovich on 02/07/2019.
//  Copyright © 2019 Neighbors. All rights reserved.
//

import UIKit

//EMAIL VALIDATION WITH REGEX:
let _firstpart = "[A-Z0-9a-z]([A-Z0-9a-z._%+-]{0,30}[A-Z0-9a-z])?"
let _serverpart = "([A-Z0-9a-z]([A-Z0-9a-z-]{0,30}[A-Z0-9a-z])?\\.){1,5}"
let _emailRegex = _firstpart + "@" + _serverpart + "[A-Za-z]{2,8}"
let _emailPredicate = NSPredicate(format: "SELF MATCHES %@", _emailRegex)

extension String {
    func isEmail() -> Bool {
        return _emailPredicate.evaluate(with: self)
    }
}

extension UITextField {
    func isEmail() -> Bool {
        return (self.text ?? "").isEmail()
    }
    
    func setError(hasError: Bool){
        if hasError{
            //changes the border of the text to red;
            self.layer.borderColor = UIColor.red.cgColor
            self.layer.borderWidth = 1
        }else{
            self.layer.borderWidth = 0
        }
    }
}
