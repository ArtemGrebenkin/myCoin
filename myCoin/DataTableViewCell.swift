//
//  DataTableViewCell.swift
//  myCoin
//
//  Created by Artem Grebenkin on 4/17/18.
//  Copyright © 2018 Artem Grebenkin. All rights reserved.
//

import UIKit

class DataTableViewCell: UITableViewCell {

    
    @IBOutlet weak var datePickUpLabel: UILabel!
    @IBOutlet weak var coinNameLabel: UILabel!
    @IBOutlet weak var newCoinImage: UIImageView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
