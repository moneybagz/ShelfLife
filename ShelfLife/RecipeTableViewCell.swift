//
//  RecipeTableViewCell.swift
//  ShelfLife
//
//  Created by Clyfford Millet on 4/20/17.
//  Copyright © 2017 Clyff Millet. All rights reserved.
//

import UIKit

class RecipeTableViewCell: UITableViewCell {

    @IBOutlet var recipeNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
