//
//  ChooseBarberViewController.swift
//  BarberShop
//
//  Created by Daniel Radshun on 21/06/2019.
//  Copyright © 2019 Neighbors. All rights reserved.
//

import UIKit

class ChooseBarberViewController: UIViewController {
    @IBOutlet weak var chooseBarberLabel: UILabel!
    
    var barbers:[Barber]?
    var appointment:Appointment?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //setting the background
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
    }

    
}

private let reuseIdentifier = "barberCell"

var pointX:CGFloat?
var pointY:CGFloat?
var imageView:UIImageView?
var barberIndex:IndexPath?

extension ChooseBarberViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return barbers?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! BarberCollectionViewCell
        
        let barber = barbers![indexPath.row]
        
        cell.populate(barber:barber)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 10
        let collectionViewSize = collectionView.frame.size.width - padding
        
        //if there are more than two barbers present 2 in each row
        if barbers!.count > 2{
            return CGSize(width: collectionViewSize/2, height: collectionViewSize/1.5)
        }
        //else present them one above another
        else{
            return CGSize(width: collectionViewSize/1.9, height: collectionViewSize/1.5)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //define the index that passed to the next screen
        barberIndex = indexPath
        
        //define the collection view point in the global view
        let point = collectionView.layoutAttributesForItem(at: indexPath)?.center ?? collectionView.center
        let pointInGlobalView = collectionView.convert(point, to: collectionView.superview)
        
        //minus a constant value to fix the position of the new image
        pointX = pointInGlobalView.x - view.frame.maxX/9
        pointY = pointInGlobalView.y - view.frame.maxY/11.4
        
        //init the imageView woth all the properties and add it to the view
        imageView = UIImageView(image: barbers![indexPath.item].image)
        imageView!.frame = CGRect(x: pointX!, y: pointY!, width: 80, height: 80)
        imageView!.layer.cornerRadius = imageView!.frame.height/2
        imageView!.layer.masksToBounds = false
        imageView!.clipsToBounds = true
        self.view.addSubview(imageView!)
        
        //animate the imageView to pop and fade all the rest of the view
        UIView.animate(withDuration: 0.24, animations: {
            
            collectionView.alpha = 0
            self.chooseBarberLabel.alpha = 0
            imageView!.transform = CGAffineTransform(scaleX: 2, y: 2)
            
        }) { (_) in
            //pass to the next screen
            self.performSegue(withIdentifier: "toSelectWhen", sender: self.barbers)
            imageView!.removeFromSuperview()
            //after a little delay we set back the alpha to 1 so when the user presses back the current view will be seen
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                collectionView.alpha = 1
                self.chooseBarberLabel.alpha = 1
            })
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let id = segue.identifier,
                let dest = segue.destination as? ChooseWhenViewController,
                let specializedBarbers = sender as? [Barber]
                else {return}
        
        //set the navigation back item title of the next screen
        let backItem = UIBarButtonItem()
        backItem.title = "בחירת ספר"
        navigationItem.backBarButtonItem = backItem
        
        if id == "toSelectWhen"{
            //pass all the nessesery data
            //the position og the imageView
            dest.passedPointX = pointX!
            dest.passedPointY = pointY!
            //the imageView inselt
            dest.chosenBarberImage = imageView!
            //the chosen barber indexPath
            dest.chosenBarberIndex = barberIndex
            
            //pass the specialized barbers
            dest.barbers = specializedBarbers
            
            appointment?.barber = barbers?[barberIndex!.row]
            dest.appointment = appointment
        }
    }

}
