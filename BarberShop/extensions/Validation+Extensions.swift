//
//  validation+extensions.swift
//  BarberShop
//
//  Created by Daniel Fraimovich on 02/07/2019.
//  Copyright © 2019 Neighbors. All rights reserved.
//

import UIKit

//EMAIL VALIDATION WITH REGEX:
let firstPart = "[A-Z0-9a-z]([A-Z0-9a-z._%+-]{0,30}[A-Z0-9a-z])?"
let serverPart = "([A-Z0-9a-z]([A-Z0-9a-z-]{0,30}[A-Z0-9a-z])?\\.){1,5}"
let emailRegex = firstPart + "@" + serverPart + "[A-Za-z]{2,8}"
let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
//full name validation:
//let fullNameRegex = "^[a-zA-Z]{2,20}$"
//let fullNamePredicate = NSPredicate(format: "SELF MATCHES %@", fullNameRegex)

extension String {
    func isEmail() -> Bool {
        return emailPredicate.evaluate(with: self)
    }
    func isPhoneNumber() -> Bool{
            let invalidCharacters = CharacterSet(charactersIn: "0123456789").inverted
            return self.rangeOfCharacter(from: invalidCharacters) == nil && self.count == 10 && self.first == "0"
    }
    
    func isFullName() -> Bool{
        return self.contains(" ")
//        return fullNamePredicate.evaluate(with: self)
    }
}

extension UITextField {
    func isEmail() -> Bool {
        return (self.text ?? "").isEmail()
    }
    
    func isPhoneNumber() -> Bool {
            return (self.text ?? "").isPhoneNumber()
    }
    
    func isFullName() -> Bool{
        return (self.text ?? "").isFullName()
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
        
        self.addTarget(self, action: #selector(startHighlightWhite), for: .touchDown)
        self.addTarget(self, action: #selector(stopHighlightWhite), for: .touchUpInside)
        self.addTarget(self, action: #selector(stopHighlightWhite), for: .touchUpOutside)
    }
    @objc private func startHighlightWhite(_ sender: UIButton) {
        self.layer.borderColor = #colorLiteral(red: 0.6617865562, green: 0.6578548551, blue: 0.6648103595, alpha: 1)
    }
    @objc private func stopHighlightWhite(_ sender: UIButton) {
        self.layer.borderColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
    }
    func setRoundedSquareToGreen(){
        self.layer.borderWidth = 1
        self.layer.borderColor = #colorLiteral(red: 0.3364608288, green: 0.5219866633, blue: 0.5498081446, alpha: 1)
        self.layer.cornerRadius = 10
        self.contentEdgeInsets = UIEdgeInsets(top: 7,left: 11,bottom: 7,right: 11)
        self.setTitleColor(#colorLiteral(red: 0.6617865562, green: 0.6578548551, blue: 0.6648103595, alpha: 1), for: .highlighted)
        
        self.addTarget(self, action: #selector(startHighlightGreen), for: .touchDown)
        self.addTarget(self, action: #selector(stopHighlightGreen), for: .touchUpInside)
        self.addTarget(self, action: #selector(stopHighlightGreen), for: .touchUpOutside)
    }
    
    @objc private func startHighlightGreen(_ sender: UIButton) {
        self.layer.borderColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
    }
    @objc private func stopHighlightGreen(_ sender: UIButton) {
        self.layer.borderColor = #colorLiteral(red: 0.3364608288, green: 0.5219866633, blue: 0.5498081446, alpha: 1)
    }
}

// Screen width.
public var screenWidth: CGFloat {
    return UIScreen.main.bounds.width
}

// Screen height.
public var screenHeight: CGFloat {
    return UIScreen.main.bounds.height
}

extension UIImage {
    var isPortrait:Bool {
        return size.height > size.width
    }
    var isLandscape:Bool{
        return size.width > size.height
    }
    var breadth:CGFloat{
        return min(size.width, size.height)
    }
    var breadthSize:CGSize{
        return CGSize(width: breadth, height: breadth)
    }
    var breadthRect:CGRect{
        return CGRect(origin: .zero, size: breadthSize)
    }
    var circleMasked:UIImage? {
        UIGraphicsBeginImageContextWithOptions(breadthSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        
        guard let cgImage = cgImage?.cropping(to: CGRect(origin: CGPoint(x: isLandscape ? floor((size.width - size.height) / 2) : 0, y: isPortrait  ? floor((size.height - size.width) / 2) : 0), size: breadthSize)) else { return nil }
        
        UIBezierPath(ovalIn: breadthRect).addClip()
        UIImage(cgImage: cgImage, scale: 1, orientation: imageOrientation).draw(in: breadthRect)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
}

extension UILabel{
    func calculateLinesSize() -> CGFloat {
        //maximum size posible to calculate the size of the text:
        let maxSize = CGSize(width: frame.size.width, height: CGFloat(Float.infinity))
        //the size of each character defined by the font:
        let charSize = font.lineHeight
        //the text itself:
        let text = (self.text ?? "") as NSString
        //the height of the given text frame:
        let textSize = text.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return textSize.height
    }
}
