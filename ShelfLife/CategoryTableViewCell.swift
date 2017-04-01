//
//  CategoryTableViewCell.swift
//  ShelfLife
//
//  Created by Clyfford Millet on 3/29/17.
//  Copyright © 2017 Clyff Millet. All rights reserved.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {

    @IBOutlet var categoryImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
