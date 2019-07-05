//
//  ChooseHaircutViewController.swift
//  BarberShop
//
//  Created by Daniel Radshun on 03/07/2019.
//  Copyright © 2019 Neighbors. All rights reserved.
//

import UIKit

class ChooseHaircutViewController: UIViewController {
    @IBOutlet weak var chooseServiesTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setting the background
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
        
        infoOrClose = #imageLiteral(resourceName: "info_icon")
    }

}

let prices = PricesDataSource.shared.pricesList
//to do singleton

var isDetailsShown = false
var chosenCellRow:Int?
var infoOrClose:UIImage?

extension ChooseHaircutViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return prices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "haircutCell") as! HaircutTableViewCell
        
        let haircut = prices[indexPath.row]
        
        cell.haircutType.setTitle(haircut.servies, for: .normal)
        cell.priceLabel.text = haircut.priceRange.description
        if haircut.priceRange.heighestPrice != nil{
            cell.priceLabel.font = cell.priceLabel.font.withSize(14)
        }
        else{
            cell.priceLabel.font = cell.priceLabel.font.withSize(20)
        }
        cell.setBarbers(haircut.barbers)
        
        cell.infoButton.setImage(infoOrClose, for: .normal)
        
        cell.haircutType.tag = indexPath.row
        cell.haircutType.addTarget(self, action: #selector(haircutChosen(_:)), for: .touchUpInside)
        
        cell.infoButton.tag = indexPath.row
        cell.infoButton.addTarget(self, action: #selector(showDetails(_:)), for: .touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == chosenCellRow && isDetailsShown{
            return 180
        }
        
        return 80
    }
    
    @objc func haircutChosen(_ sender:UIButton){
        let chosenIndex = sender.tag
        let specializedBarbers = prices[chosenIndex].barbers
        if specializedBarbers.count > 1{
            performSegue(withIdentifier: "toChooseBarber", sender: specializedBarbers)
        }
        else{
            performSegue(withIdentifier: "toSelectWhenWithOneBarber", sender: specializedBarbers)
        }
    }
    
    @objc func showDetails(_ sender:UIButton){
        isDetailsShown = !isDetailsShown
        if isDetailsShown{
            infoOrClose = #imageLiteral(resourceName: "close_icon")
            chosenCellRow = sender.tag
        }
        else{
            infoOrClose = #imageLiteral(resourceName: "info_icon")
        }
        
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
        
        if id == "toChooseBarber"{
            guard let dest = segue.destination as? ChooseBarberViewController else {return}
            dest.barbers = specializedBarbers
        }
        else if id == "toSelectWhenWithOneBarber"{
            guard let dest = segue.destination as? ChooseWhenViewController else {return}
            dest.barbers = specializedBarbers
            dest.chosenBarberIndex = IndexPath(row: 0, section: 0)
        }
    }
    
}
