//
//  CoinCellTableViewCell.swift
//  myCoin
//
//  Created by Artem Grebenkin on 4/7/18.
//  Copyright © 2018 Artem Grebenkin. All rights reserved.
//

import UIKit

class CoinCellTableViewCell: UITableViewCell {

    @IBOutlet weak var coinImage: UIImageView!

    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
