//
//  CoinsData+CoreDataProperties.swift
//  myCoin
//
//  Created by Artem Grebenkin on 6/17/19.
//  Copyright © 2019 Artem Grebenkin. All rights reserved.
//
//

import Foundation
import CoreData


extension CoinsData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CoinsData> {
        return NSFetchRequest<CoinsData>(entityName: "CoinsData")
    }

    @NSManaged public var currency: String?
    @NSManaged public var datePickUp: NSDate?
    @NSManaged public var generalySign: Bool
    @NSManaged public var latitude: Double
    @NSManaged public var locationDescription: String?
    @NSManaged public var longitude: Double
    @NSManaged public var metal: Bool
    @NSManaged public var name: String?
    @NSManaged public var rating: Int16
    @NSManaged public var uid: String?

}
