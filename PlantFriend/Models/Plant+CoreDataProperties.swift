//
//  Plant+CoreDataProperties.swift
//  PlantFriend
//
//  Created by Sarah Ragowski on 19.12.19.
//  Copyright © 2019 Sarah Ragowski. All rights reserved.
//
//

import Foundation
import CoreData


extension Plant {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Plant> {
        return NSFetchRequest<Plant>(entityName: "Plant")
    }

    @NSManaged public var image: Data?
    @NSManaged public var lastWaterDate: String?
    @NSManaged public var name: String?
    @NSManaged public var waterInterval: Int32
    @NSManaged public var person: Person?

}
