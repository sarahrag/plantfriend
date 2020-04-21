//
//  ProfileViewController.swift
//  PlantFriend
//
//  Created by Sarah Ragowski on 10.12.19.
//  Copyright © 2019 Sarah Ragowski. All rights reserved.
//

import UIKit
import CoreData

/**
    ProfileViewController:
    ViewController for the Profile.storyboard to see the personal profile and a overview of the plants. Its also possible to delete the profile or all Plants.
 */
class ProfileViewController: UIViewController {
    
    private var plantList = [Plant]()
    private var person: Person!
    private var currentPlant: Plant!
    
    @IBOutlet weak var noPlantsButton: UIButton!
    @IBOutlet weak var plantCollectionView: UICollectionView!
    @IBOutlet weak var deletePlantsButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var plantLabel: UILabel!
    @IBOutlet weak var profilePicture: UIImageView!
    
    /**
        Button that is available when the user has no plants to delegate he to the addPlantView
     */
    @IBAction func noPlantsButtonAction(_ sender: UIButton) {
        tabBarController?.selectedIndex = 1
    }
    
    /**
        Function that opens a PopUp when the segue source is the CreateProfileViewController
     */
    @IBAction func popDid(_ segue: UIStoryboardSegue){
        if let source = segue.source as? CreateProfileViewController{
            person = source.person
            helloPopUp()
        }
    }

    /**
        Action for the Button to delete the Profile. It calls a method to open a popUp
     */
    @IBAction func deleteProfile(_ sender: UIButton) {
        deleteProfilePopUp()
    }
    
    /**
        Action for the Button to delete all Plants. It calls a method to open a popUp
     */
    @IBAction func deletePlants(_ sender: UIButton) {
        deletePlantsPopUp()
    }
    
    /**
         Function to show a popUp when the user just created the profile
    */
    private func helloPopUp(){
        let alertController = UIAlertController(title: "❤️-lich Willkommen", message:
            "Du hast dein Profil erstellt!", preferredStyle: .alert)

        self.present(alertController, animated: true, completion: nil)
        
        let when = DispatchTime.now() + 2
        DispatchQueue.main.asyncAfter(deadline: when){
          alertController.dismiss(animated: true, completion: nil)
        }
    }
    
    /**
         Function to show a popUp when the user wants to delete all Plants
    */
    private func deletePlantsPopUp(){
        let alert = UIAlertController(title: "Willst du wirklich alle eine Pflanzen löschen?", message: "", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Ja", style: .default, handler: { action in
            self.person = self.loadPerson()
            
            self.deletePlants(person: self.person)
            self.updateUI()
        }))
        alert.addAction(UIAlertAction(title: "Nein", style: .cancel, handler: { action in
              alert.dismiss(animated: true, completion: nil)
            
        }))

        self.present(alert, animated: true)
    }
    
    /**
         Function to show a popUp when the user wants to delete the profile
    */
    private func deleteProfilePopUp(){
        let alert = UIAlertController(title: "Willst du wirklich dein Profil löschen?", message: "", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Ja", style: .default, handler: { action in
            self.deleteProfile()
        }))
        alert.addAction(UIAlertAction(title: "Nein", style: .cancel, handler: { action in
              alert.dismiss(animated: true, completion: nil)
        }))

        self.present(alert, animated: true)
    }
    
    /**
        Function to delete the Profile in the coredata
     */
    private func deleteProfile(){
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Person")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
            
            self.performSegue(withIdentifier: "createProfile", sender: self)
        } catch {
            print("error during deletion of profile")
        }
    }
    
    /**
        Function to delete alle Plants of the Person
     */
    private func deletePlants(person: Person){
        let plants = person.plant
        person.removeFromPlant(plants!)
        try? context.save()

    }
    

    /**
        Function to set the delegate and datasource of the collectionview and load the person
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        person = loadPerson()
        
        plantCollectionView.delegate = self
        plantCollectionView.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateUI()
    }
    
    /**
        Function to load the Person from the coredata
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
        Function to test whether the person exists
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
        Function to update the UI: load the plantList, reload the Collectionview, set the labels and show a Button if the plantlist is empty
     */
    private func updateUI() {
        
        plantList = person.plant?.allObjects as! [Plant]
        plantCollectionView.reloadData()
        
        nameLabel.text = person!.name
        
        plantLabel.text = "Meine Pflanzen (" + String(person!.plant!.count) + ")"
        
//        print(!person.profilePic!.isEmpty)
        if(person.profilePic?.isEmpty != nil){
            profilePicture.image = UIImage(data: person.profilePic!)
        }
        
        if(plantList.count == 0){
            noPlantsButton.setTitle("Füge jetzt deine erste Pflanze hinzu 🌿", for: .normal)
            noPlantsButton.isEnabled = true
            deletePlantsButton.isEnabled = false
            deletePlantsButton.isHidden = true
        }else{
            noPlantsButton.setTitle("", for: .normal)
            noPlantsButton.isEnabled = false
            deletePlantsButton.isEnabled = true
            deletePlantsButton.isHidden = false
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
 extension for the collectionview to fill the cells
 */
extension ProfileViewController: UICollectionViewDataSource{
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView,
                               numberOfItemsInSection section: Int) -> Int {
    return plantList.count
  }
    
    
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "plantCell", for: indexPath) as! UIPlantsCollectionViewCell
    // Configure the cell
    cell.model = plantList[indexPath.row]
    
    return cell
  }
    
    
}

/**
 Extension to handle the cklick on the cell
 */
extension ProfileViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

            
        currentPlant = plantList[indexPath.item]
        
        performSegue(withIdentifier: "plantDetailSegue", sender: self)
        
      
    }
}


