//
//  ViewController.swift
//  BarberShop
//
//  Created by Daniel Radshun on 17/06/2019.
//  Copyright © 2019 Neighbors. All rights reserved.
//

import UIKit

class PricesViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setting the background
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
        self.navigationController?.navigationBar.setBackgroundImage(#imageLiteral(resourceName: "background"), for: .default)
        
        //setting the "back" button to white
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
    }

}

let pricesList = PricesDataSource.shared.pricesList

extension PricesViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pricesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "priceCell") as! PriceTableViewCell
        
        let priceItem = pricesList[indexPath.row]
        
        cell.serviesLabel.text = priceItem.servies
        cell.priceLabel.text  = priceItem.priceRange.description
        if priceItem.priceRange.heighestPrice != nil{
            cell.priceLabel.font = cell.priceLabel.font.withSize(14)
        }
        else{
            cell.priceLabel.font = cell.priceLabel.font.withSize(22)
        }
        cell.backgroundColor = UIColor.clear
        cell.backgroundView = nil
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
}
