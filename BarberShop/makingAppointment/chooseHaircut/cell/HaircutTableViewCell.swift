//
//  HaircutTableViewCell.swift
//  BarberShop
//
//  Created by Daniel Radshun on 03/07/2019.
//  Copyright © 2019 Neighbors. All rights reserved.
//

import UIKit

class HaircutTableViewCell: UITableViewCell {
    @IBOutlet weak var haircutType: UIButton!
    @IBOutlet weak var infoButton: UIButton!
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var barbersCollection: UICollectionView!
    
    var barbers:[Barber]?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        barbersCollection.delegate = self
        barbersCollection.dataSource = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setBarbers(_ barbers:[Barber]){
        self.barbers = barbers
        barbersCollection.reloadData()
    }

}

extension HaircutTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return barbers?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "barbersHaircut", for: indexPath) as! HaircutDetailsCollectionViewCell
        
        cell.barberImage.image = barbers?[indexPath.row].image
        
        return cell
    }
    
}
