//
//  PlantDetailViewController.swift
//  PlantFriend
//
//  Created by Sarah Ragowski on 26.12.19.
//  Copyright © 2019 Sarah Ragowski. All rights reserved.
//

import UIKit
import CoreData

/**
    PlantDetailViewController:
    ViewController for the PkantDetailView.storyboard to show a detail Overview of a selected Plant with  the Name, the Picture, the days till water it, a button to check off the water and the posibilaty to delete the plant
 */
class PlantDetailViewController: UIViewController {
    
    var person: Person!
    var currentPlant: Plant!
    
    
    @IBOutlet weak var plantNameLabel: UIColorLabel!
    @IBOutlet weak var plantImageView: UIImageView!
    @IBOutlet weak var waterLabel: UILabel!
    @IBOutlet weak var wateredButton: UIButton!
    
    /**
        Action when the wateredButton is tapped. It disbales the button and set the plant watered
     */
    @IBAction func watererButtonAction(_ sender: UIButton) {

        wateredButton.isEnabled = false
        
        currentPlant.setWatered()
        updateUI()
    }
    
    /**
        Function to call the popUp()-method due clicking on the deletePlantButton
     */
    @IBAction func deletePlantButton(_ sender: UIButton) {
        popUp()

    }
    
    /**
        Function to reset the waterLabel
     */
    private func updateUI(){
        var days = " Tagen"
        
        if (currentPlant.getDaysTillWater() == 1 || currentPlant.getDaysTillWater() == -1){
            days = " Tag"
        }
        
        if(currentPlant.getDaysTillWater() < 0){
            waterLabel.text = "Zu gießen vor " + String(-currentPlant.getDaysTillWater()) + days
        }else{
            waterLabel.text = "Zu gießen in " + String(currentPlant.getDaysTillWater()) + days
        }
        
    }
    
    /**
        popUp Function to check if the user really want to delete the plant and eventualle delete the plant
     */
    private func popUp(){
        let alert = UIAlertController(title: "Willst du wirklich " + currentPlant.name! + " löschen?", message: "", preferredStyle: .alert)
        print("hallo popup")

        alert.addAction(UIAlertAction(title: "Ja", style: .default, handler: { action in
            self.person.removeFromPlant(self.currentPlant)
            try? context.save()
            self.navigationController?.popViewController(animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Nein", style: .cancel, handler: { action in
              alert.dismiss(animated: true, completion: nil)
            
        }))

        self.present(alert, animated: true)
    }
    

    /**
        Function that set the labels, the image and the button
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        person = loadPerson()
        
        plantNameLabel.text = currentPlant.name
        
        var days = " Tagen"
        
        if (currentPlant.getDaysTillWater() == 1 || currentPlant.getDaysTillWater() == -1){
            days = " Tag"
        }
        
        if(currentPlant.getDaysTillWater() < 0){
            waterLabel.text = "Zu gießen vor " + String(-currentPlant.getDaysTillWater()) + days
        }else{
            waterLabel.text = "Zu gießen in " + String(currentPlant.getDaysTillWater()) + days
        }
    
        
        if !currentPlant.image!.isEmpty{
            plantImageView.image = UIImage(data: currentPlant.image!)
        }
        
        if(currentPlant.getDaysTillWater() > 3){
            wateredButton.isEnabled = false
        }else{
            wateredButton.isEnabled = true
        }

    }
    
    /**
        Function to load the person from the coredata
     */
    private func loadPerson() -> Person?{
        let request: NSFetchRequest<Person> = Person.fetchRequest()
        let persons = try? context.fetch(request)
        if !isEmpty() {
            return persons![0] as Person
    
        }else{
            return nil
        }
    }
    
    /**
        Function to check if the person exists
     */
    private func isEmpty() -> Bool{
        do {
            let request: NSFetchRequest<Person> = Person.fetchRequest()
            let count  = try context.count(for: request)
            return count == 0
        } catch {
            return true
        }
    }
    

}
