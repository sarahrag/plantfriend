//
//  AddPantViewController.swift
//  PlantFriend
//
//  Created by Sarah Ragowski on 09.12.19.
//  Copyright © 2019 Sarah Ragowski. All rights reserved.
//

import UIKit
import CoreData
import AVKit
import AVFoundation

let context = AppDelegate.viewContext

/**
    AddPlantViewController:
    ViewController for the AddPlant.storyboard to name the Plant, give it a picture, set the last water date and the time interval to water it in future
 */
class AddPlantViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    private let dateFormatter = DateFormatter()
    private var plantNameDict = [String: Int]()
    private var days: Int!
    private var selectedName: String!
    private var picture = false
    private var cameraUsed = false
    private let defaultPicColor = UIImage(named: "PlantDefaultColor")
    private let defaultPic = UIImage(named: "CameraIcon")

    
    @IBOutlet weak var plantName: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var waterReference: UIColorLabel!
    @IBOutlet weak var waterIntervallTextField: UITextField!
    @IBOutlet weak var plantImageView: UIImageView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    /**
        Action for a Button that gives a suggestion for the Plant species that gives you a recommandation for the WaterInverval
     */
    @IBAction func plantNameButton(_ sender: UIButton) {
        waterReference.text = "  Empfehlung: " + String(days) + " Tage  "
        nameTextField.text = selectedName
        nameTextField.resignFirstResponder()
        waterIntervallTextField.text = String(days)
    }
    
    /**
        Function to close the keyboard while using the datepicker
     */
    @IBAction func datePickerChanged(_ sender: UIDatePicker) {
        view.endEditing(true)
    }
    
    /**
        TabGesture when the keyboard is open to tap outside of it to close it
     */
    @IBAction func tabGesture(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @IBAction func addImage(_ sender: Any) {
        openActionsheet()
    }

    /**
        Function that react when the textfield changes to give the suggestion of the plantspecies
     */
    @IBAction func textFieldChanges(_ sender: UITextField) {
        for name in plantNameDict.keys{
            if(name.contains(String(nameTextField.text!))){
                plantName.setTitle(name + "?", for: .normal)
                days = plantNameDict[name]
                selectedName = name
                break
            }else{
                plantName.setTitle("", for: .normal)
            }
        }
            
    }
    
    /**
        Action for a Button to add the new Plant. It checks whether all textfileds arent empty, calls the saveData method and clear all textfields
     */
    @IBAction func addPlant(_ sender: Any) {
//       viewTapped()
        
        if nameTextField.text == ""{
            nameTextField.layer.borderWidth = 0.5
            nameTextField.layer.borderColor = UIColor.red.cgColor
        }
        if waterIntervallTextField.text == ""{
            waterIntervallTextField.layer.borderWidth = 0.5
            waterIntervallTextField.layer.borderColor = UIColor.red.cgColor
        }
        
        if nameTextField.text != "" && waterIntervallTextField.text != ""  {
            let plant: Plant = Plant(context: context)
            
            saveData(plant: plant)
            
            nameTextField.text = ""
            nameTextField.layer.borderColor = UIColor.black.cgColor
            nameTextField.layer.borderWidth = 0
            waterIntervallTextField.text = ""
            waterIntervallTextField.layer.borderColor = UIColor.black.cgColor
            waterIntervallTextField.layer.borderWidth = 0
            datePicker.date = Date()
            plantImageView.image = defaultPic
            plantName.setTitle("", for: .normal)
            waterReference.text = ""
            picture = false
            
            tabBarController?.selectedIndex = 2
            
        }

    }
    
    /**
        Function to load the PlantList for the suggestion of the plantspecies
     */
    private func loadPlantList(){
        plantNameDict["Delicosa"] = 7
        plantNameDict["Kaktus"] = 28
        plantNameDict["Aloe Vera"] = 14
        plantNameDict["Monstera"] = 9
        plantNameDict["Anthurium"] = 7
        plantNameDict["Haworthia Fasciata"] = 10
      }
      
      /**
        Function to open the actionssheet to choose which imagesource should be used
     */
      private func openActionsheet(){
          let alert = UIAlertController(title: "Woher soll das Bild kommen?", message: nil, preferredStyle: .actionSheet)
          alert.addAction(UIAlertAction(title: "Kamera", style: .default, handler: { _ in
              self.camera()
          }))

          alert.addAction(UIAlertAction(title: "Galerie", style: .default, handler: { _ in
              self.gallery()
          }))

          alert.addAction(UIAlertAction.init(title: "Abbrechen", style: .cancel, handler: nil))

          self.present(alert, animated: true, completion: nil)
      }
      
     /**
        Function to set the imagepicker to the camera and open it
    */
      private func camera(){
          if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
              let imagePicker = UIImagePickerController()
              imagePicker.delegate = self
              imagePicker.sourceType = UIImagePickerController.SourceType.camera
              imagePicker.allowsEditing = false
              self.present(imagePicker, animated: true, completion: nil)
              cameraUsed = true
          }
          else
          {
              let alert  = UIAlertController(title: "Warnung", message: "Es sieht so aus als hättest du keine Kamera", preferredStyle: .alert)
              alert.addAction(UIAlertAction(title: "Ok :-(", style: .default, handler: nil))
              self.present(alert, animated: true, completion: nil)
          }
          
      }
      
      /**
        Function to set the imagepicker to the gallery and open it
     */
      private func gallery(){
          if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
              let imagePicker = UIImagePickerController()
              imagePicker.delegate = self
              imagePicker.allowsEditing = false
              imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
              self.present(imagePicker, animated: true, completion: nil)
              cameraUsed = true
          }
          else
          {
              let alert  = UIAlertController(title: "Warnung", message: "Es sieht so aus als dürften wir nicht auf deine Galerie zugreifen", preferredStyle: .alert)
              alert.addAction(UIAlertAction(title: "Ok :-(", style: .default, handler: nil))
              self.present(alert, animated: true, completion: nil)
          }
      
      }
      
      /**
        Function to set the picture the the imageView at the storyboard
     */
      func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
          
          if let pickedImage = info[.originalImage] as? UIImage {
              plantImageView.image = pickedImage
              if(cameraUsed){
                  plantImageView.image = plantImageView.image?.rotate(radians: CGFloat.pi*2)
              }
              self.picture = true
          }
          picker.dismiss(animated: true, completion: nil)
      }
    
    /**
        Function to save the Plant
     */
    func saveData(plant: Plant){
        plant.setValue(nameTextField.text!, forKey: "name")
        plant.setValue(datePicker.date, forKey: "waterDate")
        plant.setValue(Int(waterIntervallTextField.text!), forKey: "waterInterval")
        
        var imageData: Data
        
        if (picture) {     // plantImageView!.image != nil
            let img = plantImageView!.image
            imageData = (img!.pngData())!
        }else{
            imageData = (defaultPicColor?.pngData())!
        }

                
        plant.image = imageData
        
        let person = loadPerson()
        
        person?.addToPlant(plant)
        

        try? context.save()
        
        if(person?.plant?.count == 1 || person?.plant?.count == 5 || person?.plant?.count == 10 || person?.plant?.count == 20  || person?.plant?.count == 50 || person?.plant?.count == 100){
            popUp2(zahl: String((person?.plant?.count)!))
        }
        
    }
    
    /**
        Function for a popUp with a gif that dismiss after 3 seconds
     */
    private func popUp2(zahl: String){
        let alertController = UIAlertController(title: "Wuuhuu 🎉", message:
            "Du hast deine " + zahl + ". Pflanze hochgeladen!", preferredStyle: .alert)
        
        let gifView = UIImageView(frame: CGRect(x: 15, y: 80, width: 220, height: 220))
        
        gifView.loadGif(name: "Plant")
        
        alertController.view.addSubview(gifView)
        let height = NSLayoutConstraint(item: alertController.view as Any, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 320)
        let width = NSLayoutConstraint(item: alertController.view as Any, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 250)
        alertController.view.addConstraint(height)
        alertController.view.addConstraint(width)
        

        self.present(alertController, animated: true, completion: nil)
        
        let when = DispatchTime.now() + 3
        DispatchQueue.main.asyncAfter(deadline: when){
          alertController.dismiss(animated: true, completion: nil)
        }
        
    }

    /**
        Function to load the person. We need this to save the plant to the person
     */
    func loadPerson() -> Person?{
        let request: NSFetchRequest<Person> = Person.fetchRequest()
        let persons = try? context.fetch(request)
        if !isEmpty() {
            return persons![0] as Person
    
        }else{
            return nil
        }
    }
    
    /**
        checks whether the person is existent
     */
    func isEmpty() -> Bool{
        do {
            let request: NSFetchRequest<Person> = Person.fetchRequest() 
            let count  = try context.count(for: request)
            return count == 0
        } catch {
            return true
        }
    }
    
    /**
        viewDidload to set the textfileds delegates, load the plantList and  configure the datepicker
     */
    override func viewDidLoad() {
        super.viewDidLoad()

        waterIntervallTextField.delegate = self
        nameTextField.delegate = self
        
        loadPlantList()
        
        plantName.setTitle("", for: .normal)
        waterReference.text = ""
        
        dateFormatter.dateFormat = "MM/dd/yyyy"
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "ger")
        datePicker.maximumDate = Date()

    }
    
    @objc func viewTapped(){
       self.view.endEditing(true)
    }
    
}


/**
    extension UIImage:
    Extension for UIImage to rotate a image
 */
extension UIImage {
    func rotate(radians: CGFloat) -> UIImage {
        let rotatedSize = CGRect(origin: .zero, size: size)
            .applying(CGAffineTransform(rotationAngle: CGFloat(radians)))
            .integral.size
        UIGraphicsBeginImageContext(rotatedSize)
        if let context = UIGraphicsGetCurrentContext() {
            let origin = CGPoint(x: rotatedSize.width / 2.0,
                                 y: rotatedSize.height / 2.0)
            context.translateBy(x: origin.x, y: origin.y)
            context.rotate(by: radians)
            draw(in: CGRect(x: -origin.y, y: -origin.x,
                            width: size.width, height: size.height))
            let rotatedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()

            return rotatedImage ?? self
        }

        return self
    }
}
