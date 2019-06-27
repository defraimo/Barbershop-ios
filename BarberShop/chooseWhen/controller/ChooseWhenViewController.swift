//
//  ChooseWhenViewController.swift
//  BarberShop
//
//  Created by Daniel Radshun on 21/06/2019.
//  Copyright © 2019 Neighbors. All rights reserved.
//

import UIKit

class ChooseWhenViewController: UIViewController {
    @IBOutlet weak var barbersCollection: UICollectionView!
    @IBOutlet weak var arrowRight: UIImageView!
    @IBOutlet weak var arrowLeft: UIImageView!
    @IBAction func arrowRightTapped(_ sender: UITapGestureRecognizer) {
//        guard let currentIndex = barbersCollection.indexPathsForVisibleItems[0] else {return}
//        print(currentIndex.row)
//        if currentIndex.row < barbers.count{
//            barbersCollection.scrollToItem(at: IndexPath(row: currentIndex.row+1, section: currentIndex.section), at: .right, animated: true)
//        }
        
        
//        let visibleItems: NSArray = barbersCollection.indexPathsForVisibleItems as NSArray
//        let currentItem: IndexPath = visibleItems.object(at: 0) as! IndexPath
//        let nextItem: IndexPath = IndexPath(item: currentItem.item + 1, section: 0)
//        if nextItem.row < barbers.count {
//            barbersCollection.scrollToItem(at: nextItem, at: .left, animated: true)
//
//        }
    }
    @IBAction func arrowLeftTapped(_ sender: UITapGestureRecognizer) {
        let visibleItems: NSArray = barbersCollection.indexPathsForVisibleItems as NSArray
        let currentItem: IndexPath = visibleItems.object(at: 0) as! IndexPath
        if currentItem.row == 0{
            arrowLeft.alpha = 0
        }
        else{
            arrowLeft.alpha = 0.4
        }
        let nextItem: IndexPath = IndexPath(item: currentItem.item - 1, section: 0)
        if nextItem.row < barbers.count && nextItem.row >= 0{
            barbersCollection.scrollToItem(at: nextItem, at: .right, animated: true)
            
        }
    }
    @IBOutlet weak var datePicker: UIPickerView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //setting the background
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
        
        self.navigationItem.leftBarButtonItem?.title = "חזור"
        
    }

}

private let reuseIdentifier = "barberChooseCell"

extension ChooseWhenViewController: UICollectionViewDataSource,UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return barbers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! BarberChangeCollectionViewCell
        
        let barber = barbers[indexPath.row]
        
        cell.populate(barber:barber)
        
        return cell
    }
}

let daniel = BarbersSchedule()
let danielsDays = daniel.allDays
let danielsAvialibleDays = daniel.avialibleDays

extension ChooseWhenViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return danielsDays.count
    }
    
    //sets the title and the color of the picker component
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        if row < danielsAvialibleDays{
            let attributedString = NSAttributedString(string: danielsDays[row].description, attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
            return attributedString
        }
        else{
            let attributedString = NSAttributedString(string: danielsDays[row].description, attributes: [NSAttributedString.Key.foregroundColor : UIColor(red: 255/255, green: 110/255, blue: 100/255, alpha: 250/255)])
            return attributedString
        }
    }
}
