//
//  BarberDescriptionTableViewCell.swift
//  BarberShop
//
//  Created by Daniel Radshun on 18/06/2019.
//  Copyright © 2019 Neighbors. All rights reserved.
//

import UIKit

class BarberDescriptionTableViewCell: UITableViewCell {
    @IBOutlet weak var barberImage: UIImageView!
    @IBOutlet weak var barberDescription: UILabel!
    @IBOutlet weak var barberName: UILabel!
    @IBOutlet weak var imageBackground: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
