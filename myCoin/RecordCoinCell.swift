//
//  RecordCoinCell.swift
//  myCoin
//
//  Created by Artem Grebenkin on 6/7/18.
//  Copyright © 2018 Artem Grebenkin. All rights reserved.
//

import Foundation

struct RecordCoinCell {
    
    var datePickUp: NSDate?
    var uid: String?
    var latitude: Double
    var longitude: Double
    var locationDescription: String?
    var coin: Coin?
    
    init() {
        datePickUp = nil
        uid = nil
        latitude = 0
        longitude = 0
        locationDescription = nil
        coin = nil
    }
}
