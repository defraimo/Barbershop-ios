//
//  HaircutTableViewCell.swift
//  BarberShop
//
//  Created by Daniel Radshun on 03/07/2019.
//  Copyright © 2019 Neighbors. All rights reserved.
//

import UIKit

class HaircutTableViewCell: UITableViewCell {
    @IBOutlet weak var haircutType: UILabel!
    @IBOutlet weak var infoButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
