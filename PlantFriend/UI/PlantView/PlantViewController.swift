//
//  PlantViewController.swift
//  PlantFriend
//
//  Created by Sarah Ragowski on 03.12.19.
//  Copyright © 2019 Sarah Ragowski. All rights reserved.
//

import UIKit
import CoreData

/**
    PlantViewController:
    ViewController for the PlantView.storyboard to show a tableView with custom Cells for each plant.
    It helps to give a overview of the Pkants in when to water them.
 */
class PlantViewController: UIViewController {
    
    private var plantList = [Plant]()
    private var person: Person!
    private var currentPlant: Plant!

    @IBOutlet weak var PlantTable: UITableView!
    @IBOutlet weak var noPlants: UIButton!
    
    /**
        Function that opens a PopUp when the segue source is the CreateProfileViewController
     */
    @IBAction func popDid(_ segue: UIStoryboardSegue){
        if segue.source is CreateProfileViewController{
            helloPopUp()
        }
    }
    
    /**
        Button that is available when the user has no plants to delegate he to the addPlantView
     */
    @IBAction func noPlantsButton(_ sender: UIButton) {
        tabBarController?.selectedIndex = 1
    }
    
    /**
        Function to show a popUp when the user just created the profile
     */
    private func helloPopUp(){
        print("Helloooo")
        let alertController = UIAlertController(title: "❤️-lich Willkommen", message:
            "Du hast dein Profil erstellt!", preferredStyle: .alert)

        self.present(alertController, animated: true, completion: nil)
        
        let when = DispatchTime.now() + 2
        DispatchQueue.main.asyncAfter(deadline: when){
          alertController.dismiss(animated: true, completion: nil)
        }
    }

    /**
        Function to set the Tables dataSource and delegate and call the configureRefreshControl()-method
     */
    override func viewDidLoad() {
            
        super.viewDidLoad()
        
        PlantTable.dataSource = self
        PlantTable.delegate = self
        
        configureRefreshControl()
        
    }
    
    /**
        Function to add the refresh control to the TableView
     */
    func configureRefreshControl () {
       PlantTable.refreshControl = UIRefreshControl()
       PlantTable.refreshControl?.addTarget(self, action:
                                          #selector(handleRefreshControl),
                                          for: .valueChanged)
    }
      
    /**
        Function to call the updateUI()-method and dismiss the refresh control when the refresh control is shown
     */
    @objc func handleRefreshControl() {
       updateUI()
        
       DispatchQueue.main.async {
          self.PlantTable.refreshControl?.endRefreshing()
       }
    }
    
    /**
        Function to check if a profile exists and peform a segue to create one  if theres no profile
     */
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if isEmpty() {
            performSegue(withIdentifier: "createProfileSengue", sender: self)
        }else{
            person = loadPerson()
            updateUI()
        }   
        
    }
   
    /**
        Function to delete all Data --> only for testuse
     */
    private func deleteAllData() {
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Person")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
       
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print("error during deletion of profile")
        }
    }
    
    /**
        Function to check whether a profile exists
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
    
    /**
        Function to load the profile
     */
    func loadPerson() -> Person{
        let request: NSFetchRequest<Person> = Person.fetchRequest()
        let persons = try? context.fetch(request)
        if !isEmpty(){
            return persons![0] as Person
        }else{
            let person: Person = Person(context: context)
            return person
        }
    }
    
    /**
        Function to update the UI:
            When there arent Plants a Button appears
            When there are Plants the PlantList get sorted and the data of the Table get reloaded
     */
    func updateUI() {
        plantList = person.plant?.allObjects as! [Plant]
        if(plantList.count == 0){
            noPlants.setTitle("Füge jetzt deine erste Pflanze hinzu 🌿", for: .normal)
            noPlants.isEnabled = true
            PlantTable.isHidden = true
        }else{
            plantList = plantList.sorted(by: {
                $0.getDaysTillWater() < $1.getDaysTillWater()
            })
            PlantTable.isHidden = false
            PlantTable.reloadData()
            noPlants.setTitle("", for: .normal)
            noPlants.isEnabled = false
        }
    }

    /**
        Function to send the current Plant to the destination if the plantDetailSegue gets called
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "plantDetailSegue":
                    let destVC : PlantDetailViewController = segue.destination as! PlantDetailViewController
                         destVC.currentPlant = currentPlant
                break
            default:
                break
                
            }
            
        }
    }

}

/**
 Extension for the TableView to set the cells
 */
extension PlantViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return plantList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = PlantTable.dequeueReusableCell(withIdentifier: "plantCell") as! UIPlantTableViewCell
        
        cell.model = plantList[indexPath.row]
       // cell.ingredientnameLabel.text = String(indexPath.row)
        return cell
    }
    
}

/**
 Extension for the TableView to handle the click on the cell
 */
extension PlantViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentCell = PlantTable.cellForRow(at: indexPath)! as UITableViewCell

        if currentCell is UIPlantTableViewCell {
            let cell = currentCell as! UIPlantTableViewCell
            
            currentPlant = cell.model
            performSegue(withIdentifier: "plantDetailSegue", sender: self)
        }
    }
}
