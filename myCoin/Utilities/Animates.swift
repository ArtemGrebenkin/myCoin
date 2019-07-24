//
//  Animates.swift
//  myCoin
//
//  Created by Artem Grebenkin on 6/23/18.
//  Copyright © 2018 Artem Grebenkin. All rights reserved.
//

import Foundation
import UIKit

class Animates {
    
    let table: UITableView
    
    
    func animateTable() {
        table.reloadData()
        let cells = table.visibleCells
        let tableViewHeight = table.bounds.size.height
        
        for cell in cells {
            cell.transform = CGAffineTransform(translationX: 0, y: tableViewHeight)
        }
        
        var delayCounter = 0
        for cell in cells {
            UIView.animate(withDuration: 0.8, delay: Double(delayCounter) * 0.05, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                cell.transform = CGAffineTransform.identity
            }, completion: nil)
            delayCounter += 1
        }
        
        
    }
    
    init(table: UITableView) {
        self.table = table
    }
}
