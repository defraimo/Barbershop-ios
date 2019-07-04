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

let prices = PricesDataSource().pricesList
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
        cell.priceLabel.text = haircut.price
        cell.setBarbers(barbers)
        
        cell.infoButton.setImage(infoOrClose, for: .normal)
        
        cell.haircutType.tag = indexPath.row
        cell.haircutType.addTarget(self, action: #selector(haitcutChosen(_:)), for: .touchUpInside)
        
        cell.infoButton.tag = indexPath.row
        cell.infoButton.addTarget(self, action: #selector(showDetails(_:)), for: .touchUpInside)
        
        cell.sizeToFit()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == chosenCellRow && isDetailsShown{
            return 180
        }
        
        return 80
    }
    
    @objc func haitcutChosen(_ sender:UIButton){
        let chosenIndex = sender.tag
        performSegue(withIdentifier: "toChooseBarber", sender: nil)
    }
    
    @objc func showDetails(_ sender:UIButton){
        isDetailsShown = !isDetailsShown
        if isDetailsShown{
            infoOrClose = #imageLiteral(resourceName: "close_icon")
        }
        else{
            infoOrClose = #imageLiteral(resourceName: "info_icon")
        }
        
        chosenCellRow = sender.tag
        
        chooseServiesTable.reloadRows(at: [IndexPath(row: chosenCellRow!, section: 0)], with: .automatic)
    }
    
}
