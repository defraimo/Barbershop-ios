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
    
    @IBOutlet weak var barbersName: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var serviesLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBAction func makeAppointment(_ sender: UIButton) {
        if appointment != nil{
            var unitsIndex:[Int] = []
            for unit in appointment!.units!{
                unitsIndex.append(unit.index)
            }
            DAO.shared.checkIfUnitsStillAvailible(barber: appointment!.barber!, dateId: appointment!.date!.generateId(), unitsIndex: unitsIndex) { (isAvailible) in
                print(isAvailible)
            }
        }
    }
    
    var appointment:Appointment?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //setting the background
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
        
        scheduleButton.setRoundedSquareToWhite()
                
        guard let date = appointment?.date else {return}
        
        barbersName.text = appointment?.barber?.name
        dateLabel.text = "\(date.day) / \(date.month)"
        timeLabel.text = appointment?.units?.first?.startTime.description
        serviesLabel.text = appointment?.servies?.servies
        priceLabel.text = appointment?.servies?.priceRange.description
        
        //adjust the labels size to the smallest size
        var smallestFont:CGFloat = 1000 //a big font number
        var labelsToCheck:[UILabel] = [barbersName, serviesLabel, priceLabel]
        for label in labelsToCheck{
            let font = label.font.pointSize
            if font < smallestFont{
                smallestFont = font
            }
        }
        
        labelsToCheck += [dateLabel, timeLabel]
        for label in labelsToCheck{
            label.font.withSize(smallestFont)
        }
    }

}
