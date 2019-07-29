//
//  ManageAppointmentViewController.swift
//  BarberShop
//
//  Created by Daniel Radshun on 28/07/2019.
//  Copyright © 2019 Neighbors. All rights reserved.
//

import UIKit

class ManageAppointmentViewController: UIViewController {
    
    var appointment:Appointment?
    
    @IBOutlet weak var changeButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var barberNameLabel: UILabel!
    @IBOutlet weak var serviesLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBAction func change(_ sender: UIButton) {
        performSegue(withIdentifier: "toChangeAppointment", sender: appointment!)
    }
    @IBAction func cancel(_ sender: UIButton) {
        DAO.shared.eraseAppointment(userId: appointment!.clientId!, appointment: appointment!, removeFromAppointments: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //setting the background color
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
        
        changeButton.setImage(UIImage(named: "main_down_green.png")!.circleMasked!, for: .normal)
        cancelButton.setImage(UIImage(named: "main_down_green.png")!.circleMasked!, for: .normal)
        
        if let appointment = appointment{
        
        barberNameLabel.text = appointment.barber?.name
        serviesLabel.text = appointment.servies?.servies
        timeLabel.text = appointment.units?[0].description
            
        let date = appointment.date!
        dateLabel.text = "\(date.day) / \(date.month)"
        priceLabel.text = appointment.servies?.priceRange.description
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let dest = segue.destination as? ChooseHaircutViewController,
            let id = segue.identifier, id == "toChangeAppointment",
            let appointment = sender as? Appointment else {return}
        
        dest.previousAppointment = appointment
    }

}
