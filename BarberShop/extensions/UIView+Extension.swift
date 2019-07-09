//
//  ImageViewRounded.swift
//  Lec8HW
//
//  Created by Eran karaso on 27/05/2019.
//  Copyright © 2019 Eran karaso. All rights reserved.
//

import UIKit

@IBDesignable
extension UIView
{
    
    @IBInspectable var rounded: CGFloat{
        get
        {
            if layer.cornerRadius == 0{
                return 10
            }
            return layer.cornerRadius
        }
        set
        {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable
    var Circled: Bool {
        get {
            return true
        }
        set(isCircled) {
            
            layer.cornerRadius = isCircled ? (frame.size.height / 2) : 0
            
//            layer.borderWidth = isCircled ? 1 : 0
//            layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            
            layer.masksToBounds = isCircled
            clipsToBounds = isCircled
            
            aspectRatio()
        }
    }
    
    func aspectRatio() {
        translatesAutoresizingMaskIntoConstraints = false
        
        
        let constraint =
            NSLayoutConstraint(item: self,
                               attribute: NSLayoutConstraint.Attribute.height,
                               relatedBy: NSLayoutConstraint.Relation.equal,
                               toItem: self,
                               attribute: NSLayoutConstraint.Attribute.width,
                               multiplier: frame.size.height / frame.size.width,
                               constant: 0)
        
        constraint.isActive = true
        
        addConstraint(constraint)
    }
    
    func shadow(color:UIColor = .black,
                opacity:Float = 0.75,
                offset:CGSize = .init(width: 2,height: 2),
                radius:CGFloat = 5) {
        
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offset
        layer.shadowRadius = radius
        
//        ask iOS to cache the rendered shadow so that it doesn't need to be redrawn
        layer.shouldRasterize = true
        
        layer.rasterizationScale = UIScreen.main.scale
    }
}

