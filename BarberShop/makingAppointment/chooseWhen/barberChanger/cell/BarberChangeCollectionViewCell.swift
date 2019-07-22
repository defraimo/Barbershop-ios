//
//  BarberChangeCollectionViewCell.swift
//  BarberShop
//
//  Created by Daniel Radshun on 21/06/2019.
//  Copyright © 2019 Neighbors. All rights reserved.
//

import UIKit

class BarberChangeCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var barberImage: UIImageView!
    @IBOutlet weak var barberName: UILabel!
    
    func populate(barber:Barber){
        barberImage.image = barber.image?.circleMasked
        barberName.text = barber.name
    }
 
    
    override func didTransition(from oldLayout: UICollectionViewLayout, to newLayout: UICollectionViewLayout) {
         print("didTransition")
    }
    
//    override func prepareForReuse() {
//        print("Reuse")
//    }
//
//    override func didMoveToSuperview() {
//        print("Hello")
//    }
    
    
}


