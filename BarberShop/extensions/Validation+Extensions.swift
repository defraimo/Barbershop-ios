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

extension UIButton{
    func setRoundedSquareToWhite(){
        self.layer.borderWidth = 3
        self.layer.borderColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
        self.layer.cornerRadius = 10
        self.contentEdgeInsets = UIEdgeInsets(top: 7,left: 11,bottom: 7,right: 11)
        self.setTitleColor(#colorLiteral(red: 0.6617865562, green: 0.6578548551, blue: 0.6648103595, alpha: 1), for: .highlighted)
        
        self.addTarget(self, action: #selector(startHighlight), for: .touchDown)
        self.addTarget(self, action: #selector(stopHighlight), for: .touchUpInside)
        self.addTarget(self, action: #selector(stopHighlight), for: .touchUpOutside)
    }
    
    @objc private func startHighlight(_ sender: UIButton) {
        self.layer.borderColor = #colorLiteral(red: 0.6617865562, green: 0.6578548551, blue: 0.6648103595, alpha: 1)
    }
    @objc private func stopHighlight(_ sender: UIButton) {
        self.layer.borderColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
    }
}
