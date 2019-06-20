//
//  MainViewController.swift
//  BarberShop
//
//  Created by Daniel Radshun on 17/06/2019.
//  Copyright © 2019 Neighbors. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    @IBOutlet weak var imageRounded: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //setting the background
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
        self.navigationController?.navigationBar.setBackgroundImage(#imageLiteral(resourceName: "background"), for: .default)
        
        //change the navigation title color
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        //change the navigation item color
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        //setting the "getting an appoinment" image to rounded
        imageRounded.layer.cornerRadius = 42
        imageRounded.layer.masksToBounds = true
    }
    

}
