//
//  ChooseHaircutViewController.swift
//  BarberShop
//
//  Created by Daniel Radshun on 03/07/2019.
//  Copyright © 2019 Neighbors. All rights reserved.
//

import UIKit

class ChooseHaircutViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}

let prices = PricesDataSource().pricesList
//to do singleton

extension ChooseHaircutViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return prices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "haircutCell") as! HaircutTableViewCell
        return cell
    }
    
    
}
