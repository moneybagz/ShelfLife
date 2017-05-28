//
//  RecipeListTableViewCell.swift
//  ShelfLife
//
//  Created by Clyfford Millet on 5/27/17.
//  Copyright © 2017 Clyff Millet. All rights reserved.
//

import UIKit

class RecipeListTableViewCell: UITableViewCell {
    
    @IBOutlet var foodLabel: UILabel!
    @IBOutlet var amountLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
