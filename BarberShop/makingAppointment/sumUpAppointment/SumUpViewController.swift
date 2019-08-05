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
    
    @IBOutlet weak var orderIndicator: UIActivityIndicatorView!
    
    var dayOfWeek:String?
    
    @IBAction func makeAppointment(_ sender: UIButton) {
        //checks internet connection:
        if !Reachability.isConnectedToNetwork(){
            let alert = AlertService().alert(title: "אין חיבור אינטרנט", body: "אנא בדוק אם הינך מחובר לרשת האינטרנט", btnAmount: 1, positive: "אשר", negative: nil, positiveCompletion: {
                self.openWifiSettings()
            }, negativeCompletion: nil)
            
            present(alert, animated: true)
        }else{
            if appointment != nil{
            orderIndicator.startAnimating()
            
            DAO.shared.setAvailability(to:false, barber: appointment!.barber!, dateId: appointment!.date!.generateId(), units: appointment!.units!, userId: appointment!.clientId!) { (isAvailible) in
                
                if isAvailible{
                    
                    //setting the previous units to true
                    if self.previousAppointment != nil{
                        DAO.shared.eraseAppointment(userId: self.previousAppointment!.clientId!, appointment: self.previousAppointment!, removeFromAppointments: false)
                    }
                    
                    DAO.shared.writeAppoinment(self.appointment!)
                    let alert = AlertService().alert(title: "התור נקבע בהצלחה", body: "נתראה בקרוב !", btnAmount: 1, positive: "אישור", negative: nil, positiveCompletion: {
                        self.navigationController?.popToRootViewController(animated: true)
                        
                    }, negativeCompletion: nil)
                    
                    self.orderIndicator.stopAnimating()
                    self.present(alert, animated: true)
                }
                else{
                    //show dialog and take the user back to ChooseWhenViewController
                    let alert = AlertService().alert(title: "אופסי!", body: "תור זה בידיוק נתפס, אנא בחר/י תור אחר", btnAmount: 1, positive: "אישור", negative: nil, positiveCompletion: {
                        self.navigationController?.popViewController(animated: true)
                        
                    }, negativeCompletion: nil)
                    
                    self.present(alert, animated: true)
                }
            }
        }
        orderIndicator.stopAnimating()
        }
    }
    
    var appointment:Appointment?
    var previousAppointment:Appointment?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //setting the background
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
        
        scheduleButton.setRoundedSquareToWhite()
                
        guard let date = appointment?.date else {return}
        
        if var namedDay = dayOfWeek{
            namedDay = namedDay.replacingOccurrences(of: "יום ", with: "", options: NSString.CompareOptions.literal, range: nil)
            
            dateLabel.text = "\(date.month) / \(date.day) (\(namedDay))"
        }
        else{
            dateLabel.text = "\(date.day) / \(date.month)"
        }
        
        barbersName.text = appointment?.barber?.name
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