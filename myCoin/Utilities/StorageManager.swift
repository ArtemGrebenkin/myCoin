//
//  StorageManager.swift
//  myCoin
//
//  Created by Artem Grebenkin on 8/14/19.
//  Copyright © 2019 Artem Grebenkin. All rights reserved.
//

import RealmSwift

let realm = try! Realm()

class StorageManager {
    
    static func saveObject(_ record: CoinRecord) {
        try! realm.write {
            realm.add(record)
            //realm.add(record, update: true)
        }
    }
    
    static func deleteObject(_ record: CoinRecord) {
        if let childObject = record.coin {
            try! realm.write {
                realm.delete(childObject)
            }
        }
        try! realm.write {
            realm.delete(record)
        }
    }
    
//    do {
//      let realm = try Realm()
//      try realm.write {
//
//      }
//    }catch {
//      print("there is error with delete Realm object ! : \(error)")
//    }
    
    static func deleteAllObjects(){
        try! realm.write {
            realm.deleteAll()
        }
    }
}
