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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //setting the background
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
    }

}

private let reuseIdentifier = "barberCell"

extension ChooseBarberViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return barbers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! BarberCollectionViewCell
        
        let barber = barbers[indexPath.row]
        
        cell.populate(barber:barber)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 10
        let collectionViewSize = collectionView.frame.size.width - padding
        
        return CGSize(width: collectionViewSize/2, height: collectionViewSize/1.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var point = collectionView.layoutAttributesForItem(at: indexPath)?.center ?? collectionView.center
        let pointInGlobalView = collectionView.convert(point, to: collectionView.superview)
        
        if point.x > view.center.x{
            point = view.center
        }
        
        let imageView = UIImageView(image: barbers[indexPath.item].image)
        imageView.frame = CGRect(x: point.x, y: pointInGlobalView.y, width: 120, height: 120)
        imageView.layer.cornerRadius = imageView.frame.height/2
        imageView.layer.masksToBounds = false
        imageView.clipsToBounds = true
        self.view.addSubview(imageView)
        
        UIView.animate(withDuration: 0.4, animations: {
            
            collectionView.alpha = 0
            self.chooseBarberLabel.alpha = 0
            imageView.transform = CGAffineTransform(scaleX: 8, y: 8)
            imageView.alpha = 0
            
        }) { (_) in
            self.performSegue(withIdentifier: "toSelectWhen", sender: nil)
            imageView.removeFromSuperview()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                collectionView.alpha = 1
                self.chooseBarberLabel.alpha = 1
            })
        }
    }
    
}
