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
        barberImage.image = barber.image?.circleMasked
        let width = barberImage.frame.width
        barberImage.frame(forAlignmentRect: CGRect(x: 0, y: 0, width: width, height: width))
        barberName.text = barber.name
    }
}
