//
//  ChooseWhenViewController.swift
//  BarberShop
//
//  Created by Daniel Radshun on 21/06/2019.
//  Copyright © 2019 Neighbors. All rights reserved.
//

import UIKit

class ChooseWhenViewController: UIViewController {
    
    var passedPointX:CGFloat?
    var passedPointY:CGFloat?
    var chosenBarberImage:UIImageView?
    var chosenBarberIndex:IndexPath?
    
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
    
    fileprivate func imageEntryAnimation() {
        
        //set all the vies to invisible
        for view in view.subviews{
            view.alpha = 0
        }
        
        //scroll the collaction view to the chosen barber posiotion from the lase screen
        barbersCollection.scrollToItem(at: chosenBarberIndex!, at: .centeredHorizontally, animated: false)
        
        //getting the position of the current item
        let collectionPosition = barbersCollection.layoutAttributesForItem(at: chosenBarberIndex!)?.center ?? barbersCollection.center
        
        //find the collactionView position in the global view
        let pointInGlobalView = barbersCollection.convert(collectionPosition, to: view)
        
        //add the imageView that passes from the last screen to the view
        self.view.addSubview(imageView!)
        
        //animate the imageView
        UIView.animate(withDuration: 0.3, animations: {
            imageView?.center = pointInGlobalView
            imageView?.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            imageView?.alpha = 0.4
        }) { (_) in
            //animate all the views to fade in
            UIView.animate(withDuration: 0.05, animations: {
                self.barbersCollection.alpha = 1
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                    for view in self.view.subviews{
                        if ((view as? UIImageView) != nil){
                            //set the arrows alpha to 0.3 for a design reasons
                            view.alpha = 0.3
                        }
                        else{
                            view.alpha = 1
                        }
                    }
                })
            })
            //remove the image from the view
            imageView?.removeFromSuperview()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //setting the background
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
        
        self.navigationItem.leftBarButtonItem?.title = "חזור"
        
        imageEntryAnimation()
        
        //set the picker date array to the chosen barber from the last screen
        currentlyShownSchedule = barbersSchedule[chosenBarberIndex!.row]
        currentlyDaysNamed = currentlyShownSchedule?.namedDays
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
        
        //animate a little spring motion when created
        UIView.animate(withDuration: 0.2, delay: 0.4, usingSpringWithDamping: 0.5, initialSpringVelocity: 20, options: [], animations: {
            cell.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        })
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //set the picker date array to the chosen barber from the collectionView
        currentlyShownSchedule = barbersSchedule[indexPath.row]
        currentlyDaysNamed = currentlyShownSchedule?.namedDays
        
        UIView.animate(withDuration: 0.3, animations: {
            self.datePicker.alpha = 0
        }) { (_) in
            UIView.animate(withDuration: 0.3, animations: {
                self.datePicker.alpha = 1
            })
            self.datePicker.reloadAllComponents()
        }
    }
}

let barbersSchedule = BarbersSchedule().allBarbersShedule
var currentlyShownSchedule:DatesManager?
var currentlyDaysNamed:[PickerDates]?

extension ChooseWhenViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currentlyDaysNamed?.count ?? 0
    }
    
    //sets the title and the color of the picker component
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        if row < currentlyShownSchedule!.getAvialibleDays(){
            let attributedString = NSAttributedString(string: currentlyDaysNamed![row].description, attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
            return attributedString
        }
        else{
            let attributedString = NSAttributedString(string: currentlyDaysNamed![row].description, attributes: [NSAttributedString.Key.foregroundColor : UIColor(red: 255/255, green: 110/255, blue: 100/255, alpha: 250/255)])
            return attributedString
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }
    
}
