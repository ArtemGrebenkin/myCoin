//
//  CoinRecord.swift
//  myCoin
//
//  Created by Artem Grebenkin on 7/25/19.
//  Copyright © 2019 Artem Grebenkin. All rights reserved.
//

import RealmSwift

class CoinRecord: Object {
    
    @objc dynamic var datePickUp: NSDate?
    @objc dynamic var uid = ""
    @objc dynamic var latitude: Double = 0
    @objc dynamic var longitude: Double = 0
    @objc dynamic var locationDescription: String?
    @objc dynamic var coin: Coin?
    
    override static func primaryKey() -> String? {
        return "uid"
    }
    /*
    convenience init(datePickUp: NSDate?, coin: Coin?, uid: String) {
        self.init()
        self.datePickUp = datePickUp
        self.coin = coin!
        self.uid = uid
    }
 */
}
