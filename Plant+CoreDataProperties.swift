//
//  Plant+CoreDataProperties.swift
//  PlantFriend
//
//  Created by Sarah Ragowski on 14.01.20.
//  Copyright © 2020 Sarah Ragowski. All rights reserved.
//
//

import Foundation
import CoreData


extension Plant {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Plant> {
        return NSFetchRequest<Plant>(entityName: "Plant")
    }

    @NSManaged public var image: Data?
    @NSManaged public var name: String?
    @NSManaged public var waterInterval: Int32
    @NSManaged public var waterDate: Date?
    @NSManaged public var person: Person?

}
