//
//  AlertViewController.swift
//  BarberShop
//
//  Created by Daniel Fraimovich on 25/07/2019.
//  Copyright © 2019 Neighbors. All rights reserved.
//

import UIKit

class AlertViewController: UIViewController {
    @IBOutlet weak var alertView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        alertView.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
    }

}
