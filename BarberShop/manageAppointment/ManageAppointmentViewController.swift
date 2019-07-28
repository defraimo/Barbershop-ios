//
//  ManageAppointmentViewController.swift
//  BarberShop
//
//  Created by Daniel Radshun on 28/07/2019.
//  Copyright © 2019 Neighbors. All rights reserved.
//

import UIKit

class ManageAppointmentViewController: UIViewController {
    
    @IBOutlet weak var changeButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //setting the background color
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
        
        changeButton.setImage(UIImage(named: "main_down_green.png")!.circleMasked!, for: .normal)
        cancelButton.setImage(UIImage(named: "main_down_green.png")!.circleMasked!, for: .normal)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
