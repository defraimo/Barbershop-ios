//
//  BarberCollectionViewCell.swift
//  BarberShop
//
//  Created by Daniel Radshun on 21/06/2019.
//  Copyright © 2019 Neighbors. All rights reserved.
//

import UIKit

class BarberCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var barberImage: UIImageView!
    @IBOutlet weak var barberName: UILabel!
    
    func populate(barber:Barber){
        barberImage.image = barber.image
        let width = barberImage.frame.width
        barberImage.frame(forAlignmentRect: CGRect(x: 0, y: 0, width: width, height: width))
        barberImage.layer.cornerRadius = barberImage.frame.height/2
        barberImage.layer.masksToBounds = false
        barberImage.clipsToBounds = true
        barberName.text = barber.name
    }
}
