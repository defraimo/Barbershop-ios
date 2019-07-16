//
//  SumUpViewController.swift
//  BarberShop
//
//  Created by Daniel Radshun on 09/07/2019.
//  Copyright © 2019 Neighbors. All rights reserved.
//

import UIKit

class SumUpViewController: UIViewController {
    @IBOutlet weak var scheduleButton: UIButton!
    
    var appointment:Appointment?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //setting the background
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
        
        scheduleButton.setRoundedSquareToWhite()
        
        print(appointment)
    }

}
