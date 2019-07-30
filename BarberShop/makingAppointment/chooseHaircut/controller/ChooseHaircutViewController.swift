//
//  ChooseHaircutViewController.swift
//  BarberShop
//
//  Created by Daniel Radshun on 03/07/2019.
//  Copyright © 2019 Neighbors. All rights reserved.
//

import UIKit
import FirebaseAuth

class ChooseHaircutViewController: UIViewController {
    @IBOutlet weak var chooseServiesTable: UITableView!
    @IBOutlet weak var chooseServiesLabel: UILabel!
    
    var appointment:Appointment?
    var previousAppointment:Appointment?
    
    var chosenBarberIndex:IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setting the background
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
        
        //set the info picture to "info" first
        infoOrClose = #imageLiteral(resourceName: "info_icon")
        
        //setting the label size to be responsive
        chooseServiesLabel.adjustsFontSizeToFitWidth = true
        chooseServiesLabel.minimumScaleFactor = 0.2
        
        //init the appointment
        appointment = Appointment()
        //------------------------------------------------
        //------------------------------------------------
        
        if let uid = Auth.auth().currentUser?.uid{
            appointment?.clientId = uid
        }
        else{
            appointment?.clientId = "none"
        }
        
         //SET TO THE CURRENT USER
        //------------------------------------------------
        //------------------------------------------------
        
        NotificationCenter.default.addObserver(forName: .barberChosenFromInfo, object: nil, queue: .main) { [weak self] (notification) in
            
            guard let barberIndex = notification.userInfo?["barberIndex"] as? IndexPath else {return}
            guard let specializedBarbers = notification.userInfo?["specializedBarbers"] as? [Barber] else {return}
            guard let cellIndex = notification.userInfo?["cellIndex"] as? Int else {return}
            
            self?.appointment?.servies = prices?[cellIndex]
            
            self!.chosenBarberIndex = barberIndex
            self?.performSegue(withIdentifier: "toSelectWhenWithOneBarber", sender: specializedBarbers)
        }
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: .barberChosenFromInfo, object: nil)
    }

}

//get the prices list
let prices = PricesDataSource.shared.pricesList

var isDetailsShown = false
var chosenCellRow:Int?
var infoOrClose:UIImage?

extension ChooseHaircutViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return prices?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "haircutCell") as! HaircutTableViewCell
        
        guard let haircut = prices?[indexPath.row] else {return cell}
        
        cell.cellIndex = indexPath.row
        
        //defining the cell
        cell.haircutType.setTitle(haircut.servies, for: .normal)
        cell.priceLabel.text = haircut.priceRange.description
        //chose font size, if the prices are a range so the font is smaller
        if haircut.priceRange.heighestPrice != nil{
            cell.priceLabel.font = cell.priceLabel.font.withSize(14)
        }
        else{
            cell.priceLabel.font = cell.priceLabel.font.withSize(20)
        }
        //set the barbers that can do this specific work
        cell.setBarbers(haircut.barbers)
        
        //set the info image
        cell.infoButton.setImage(infoOrClose, for: .normal)
        
        //set tag to the button so we could pass the chosen row to the @objc func
        cell.haircutType.tag = indexPath.row
        //adding target to the press of the haircut type to pass to the next screen
        cell.haircutType.addTarget(self, action: #selector(haircutChosen(_:)), for: .touchUpInside)
        
        //set tag to the button so we could pass the chosen row to the @objc func
        cell.infoButton.tag = indexPath.row
        //adding target so the details would be shown
        cell.infoButton.addTarget(self, action: #selector(showDetails(_:)), for: .touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        //if in the cell the info button is pressed return 180 so the details will apear
        if indexPath.row == chosenCellRow && isDetailsShown{
            return 180
        }
        
        //in any other way return 80
        return 80
    }
    
    @objc func haircutChosen(_ sender:UIButton){
        
        guard let prices = prices else {return}
        
        let chosenIndex = sender.tag
        let specializedBarbers = prices[chosenIndex].barbers
        
        appointment?.servies = prices[chosenIndex]
        
        //if there is more than one barber that specifies to this work so pass to the choose barber screen
        if specializedBarbers.count > 1{
            performSegue(withIdentifier: "toChooseBarber", sender: specializedBarbers)
        }
        //else go to the date and time selection screen
        else{
            appointment?.barber = specializedBarbers[0]
            performSegue(withIdentifier: "toSelectWhenWithOneBarber", sender: specializedBarbers)
        }
    }
    
    @objc func showDetails(_ sender:UIButton){
        //every press switch the buttons position
        isDetailsShown = !isDetailsShown
        //change the buttons images
        if isDetailsShown{
            infoOrClose = #imageLiteral(resourceName: "close_icon")
            //set the current item that is pressed
            chosenCellRow = sender.tag
        }
        else{
            infoOrClose = #imageLiteral(resourceName: "info_icon")
        }
        
        //refresh the row that the selected item is on it
        chooseServiesTable.reloadRows(at: [IndexPath(row: chosenCellRow!, section: 0)], with: .automatic)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let id = segue.identifier,
                let specializedBarbers = sender as? [Barber]
                else {return}
        
        //set the navigation back item title of the next screens
        let backItem = UIBarButtonItem()
        backItem.title = "בחירת סוג שירות"
        navigationItem.backBarButtonItem = backItem
        
        //if there are more than one barber
        if id == "toChooseBarber"{
            guard let dest = segue.destination as? ChooseBarberViewController else {return}
            dest.barbers = specializedBarbers
            dest.appointment = appointment
            
            //if user chose to change his appointment pass the previous one
            if previousAppointment != nil{
                dest.previousAppointment = previousAppointment
            }
        }
        //if there is only one barber
        else if id == "toSelectWhenWithOneBarber"{
            guard let dest = segue.destination as? ChooseWhenViewController else {return}
            dest.barbers = specializedBarbers
            dest.chosenBarberIndex = chosenBarberIndex ?? IndexPath(row: 0, section: 0)
            dest.appointment = appointment
            
            //if user chose to change his appointment pass the previous one
            if previousAppointment != nil{
                dest.previousAppointment = previousAppointment
            }
        }
    }
    
}
