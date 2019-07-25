//
//  ShopTableViewCell.swift
//  BarberShop
//
//  Created by Daniel Fraimovich on 15/07/2019.
//  Copyright © 2019 Neighbors. All rights reserved.
//

import UIKit

class ShopTableViewCell: UITableViewCell {
    
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var details: UILabel!
    @IBOutlet weak var infoBtn: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
