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
    
    @IBAction func arrowRight(_ sender: UIButton) {
        barbersCollection.scrollToItem(at: IndexPath(row: currentBarberIndex, section: 0), at: .right, animated: true)
        if barbers!.count > currentBarberIndex + 1{
            currentBarberIndex += 1
        }
    }
    @IBAction func arrowLeft(_ sender: UIButton) {
        barbersCollection.scrollToItem(at: IndexPath(row: currentBarberIndex, section: 0), at: .left, animated: true)
        if currentBarberIndex - 1 >= 0{
            currentBarberIndex -= 1
        }
    }
    
    
    var barbers:[Barber]?
    var currentBarberIndex = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        barbersCollection.delegate = self
        barbersCollection.dataSource = self
        
        //setting the label size to be responsive
        priceLabel.adjustsFontSizeToFitWidth = true
        priceLabel.minimumScaleFactor = 0.2
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        NotificationCenter.default.post(name: .barberChosenFromInfo, object: nil, userInfo: ["barber": barbers![indexPath.item]])
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        currentBarberIndex = indexPath.row
    }
    
}

extension Notification.Name{
    static let barberChosenFromInfo = Notification.Name(rawValue: "barberChosenFromInfo")
}
