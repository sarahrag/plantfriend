//
//  Plant.swift
//  PlantFriend
//
//  Created by Sarah Ragowski on 03.12.19.
//  Copyright © 2019 Sarah Ragowski. All rights reserved.
//

import UIKit
import CoreData

/**
    Plant class as a CoreData Object
 */
@objc(Plant)
class Plant: NSManagedObject{
    
    /**
        Function to get the next Date to water the Plant
     */
    func getNextWaterDate() -> Date{
        let days = Int(self.waterInterval)
        
        return Date(timeInterval: TimeInterval(days*24*60*60), since: self.waterDate!)
    }
    
    /**
        Function to get the amount of days till to water the plant
     */
    func getDaysTillWater() -> Int{
        let calendar = Calendar.current
        
        let date1 = calendar.startOfDay(for: Date())
        let date2 = calendar.startOfDay(for: self.getNextWaterDate())

        let components = calendar.dateComponents([.day], from: date1, to: date2)
        
        return components.day!
    }
    
    /**
        Function to set the Plant watered
     */
    func setWatered(){
        self.waterDate = Date()
        try? context.save()
    }
    
}

