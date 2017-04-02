//
//  FoodItemTableViewCell.swift
//  ShelfLife
//
//  Created by Clyfford Millet on 4/2/17.
//  Copyright © 2017 Clyff Millet. All rights reserved.
//

import UIKit

class FoodItemTableViewCell: UITableViewCell {

    @IBOutlet var foodImageView: UIImageView!
    @IBOutlet var foodNameLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
