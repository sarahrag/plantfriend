//
//  CreateProfileViewController.swift
//  PlantFriend
//
//  Created by Sarah Ragowski on 17.12.19.
//  Copyright © 2019 Sarah Ragowski. All rights reserved.
//

import UIKit

/**
    CreateProfileViewController:
    ViewController for the CreateNewProfile.storyboard and CreateProfile.storyboard to create a profile with a Name and optionally a profilepicture.
 */
class CreateProfileViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var person: Person?
    private var picture = false
    private let defaultPic = UIImage(named: "UserIcon")
    
    @IBOutlet weak var profilPicture: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    
    /**
        Tab Gesture to dismiss the keyboard by tapping outside it
     */
    @IBAction func tabGesture(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
//        nameTextField.resignFirstResponder()
    }

    /**
        Button to create the profile
     */
    @IBAction func finishedButton(_ sender: UIButton) {
        done()
        
    }
    
    /**
        Button to add an image
     */
    @IBAction func addImage(_ sender: Any) {
        openActionsheet()
    }
    
    /**
        Function to open a action sheet to let the user choose where to pick the image
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
        Function to set the imagepicker to the camera
     */
    private func camera(){
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warnung", message: "Es sieht so aus als hättest du keine Kamera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok :-(", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    /**
        Function to set the imagepicker to the gallery
     */
    private func gallery(){
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = false
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warnung", message: "Es sieht so aus als dürften wir nicht auf deine Galerie zugreifen", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok :-(", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    
    }
    
    /**
        Function to set the picked image to the imageview
     */
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickedImage = info[.originalImage] as? UIImage {
             profilPicture.image = pickedImage
            self.picture = true
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    /**
        Function to check if the user key in a name
     */
    private func done(){
        person = Person(context: context)
        
        if nameTextField.text == ""{
            nameTextField.layer.borderWidth = 0.5
            nameTextField.layer.borderColor = UIColor.red.cgColor
        }else{
            saveData(person: person!)
        }
    }
    
    /**
        Function to save the Userdata to the coredata
     */
    private func saveData(person: Person){
        
        person.name = nameTextField.text
        
        var imageData: Data
        
        if (self.picture) {
            let img = profilPicture!.image?.rotate(radians: CGFloat.pi*2)
            imageData = (img!.pngData())!
        }else{
            imageData = (self.defaultPic?.pngData())!
        }
        
        person.profilePic = imageData
        
        do{
            try context.save()
            navigationController?.popViewController(animated: true)
            performSegue(withIdentifier: "backSegue", sender: self)
            self.tabBarController?.tabBar.isHidden = false
        }catch{
            print("Fehler beim speichern")
        }
        
    }

    /**
        Function that the keyboard return triggers the done()-method to end the creatprocess
     */
    func textFieldShouldReturn(_ textfield: UITextField) -> Bool {
        nameTextField.resignFirstResponder()
        done()
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        self.nameTextField.delegate = self
        self.tabBarController?.tabBar.isHidden = true
    }
//
//    @objc func viewTapped(){
//       self.view.endEditing(true)
//    }
    


}


