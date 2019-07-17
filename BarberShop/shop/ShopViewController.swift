//
//  ShopTableViewController.swift
//  BarberShop
//
//  Created by Daniel Fraimovich on 15/07/2019.
//  Copyright © 2019 Neighbors. All rights reserved.
//

import UIKit

class ShopViewController: UIViewController {

    var products:[Product]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
}

extension ShopViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    
    
}
