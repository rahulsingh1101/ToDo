//
//  ItemsTableViewCell.swift
//  CoreDataDemo
//
//  Created by Ajeet N on 23/08/20.
//  Copyright © 2020 Ajeet N. All rights reserved.
//

import UIKit

class ItemsTableViewCell: UITableViewCell {

    @IBOutlet var nameObj: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
