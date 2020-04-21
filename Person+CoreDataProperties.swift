//
//  Person+CoreDataProperties.swift
//  PlantFriend
//
//  Created by Sarah Ragowski on 26.01.20.
//  Copyright © 2020 Sarah Ragowski. All rights reserved.
//
//

import Foundation
import CoreData


extension Person {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Person> {
        return NSFetchRequest<Person>(entityName: "Person")
    }

    @NSManaged public var name: String?
    @NSManaged public var profilePic: Data?
    @NSManaged public var plant: NSSet?

}

// MARK: Generated accessors for plant
extension Person {

    @objc(addPlantObject:)
    @NSManaged public func addToPlant(_ value: Plant)

    @objc(removePlantObject:)
    @NSManaged public func removeFromPlant(_ value: Plant)

    @objc(addPlant:)
    @NSManaged public func addToPlant(_ values: NSSet)

    @objc(removePlant:)
    @NSManaged public func removeFromPlant(_ values: NSSet)

}
