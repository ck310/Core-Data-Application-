//
//  AddPersonViewController.swift
//  Assignment02
//
//  Created by C Karthika on 31/03/2022.
//

import UIKit
import CoreData

class AddPersonViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    //core data objects and functions
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var pEntity : NSEntityDescription! = nil
    var pManagedObject : People! = nil
    
    
    //function to deal with data
    func updateNewPerson(){
        //fill pManageObject with data from fields
        pManagedObject.name    = nameTextField.text
        pManagedObject.gender  = genderTextField.text
        pManagedObject.age     = ageTextField.text
        pManagedObject.phone   = contactTextField.text
        pManagedObject.details = detailView.text
        pManagedObject.image   = imageTextField.text
        
        //context saves
        do{
            try context.save()
        }catch{
            print("context cannot save")
        }
        let image = imageView.image
        //now update the image
        if image != nil && imageTextField.text != nil{
            saveImage(imageName: imageTextField.text!)
        }
    }
    
    func saveNewPerson(){
        //create a new manage object
        pEntity = NSEntityDescription.entity(forEntityName: "People", in: context)
        pManagedObject = People(entity: pEntity, insertInto: context)
        
        //fill pManageObject with data from fields
        pManagedObject.name    = nameTextField.text
        pManagedObject.gender  = genderTextField.text
        pManagedObject.age     = ageTextField.text
        pManagedObject.phone   = contactTextField.text
        pManagedObject.details = detailView.text
        pManagedObject.image   = imageTextField.text
        
        //context saves
        do{
            try context.save()
        }catch{
            print("context cannot save")
        }
        
        let image  = imageView.image
        //now update the image
        if image != nil && imageTextField.text != nil{
            saveImage(imageName: imageTextField.text!)
        }
    }

    //get image function
    func getImage(imageName:String){
        //find the location to documents to save the file
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
        let imagePath     = documentsPath.appendingPathComponent(imageName)
        //get the image from the file and place it to image view
        let image = UIImage(contentsOfFile: imagePath)
        imageView.image = image
    }
    
    //save image function
    func saveImage(imageName:String){
        //find the location to documents to save the file
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
        let imagePath = documentsPath.appendingPathComponent(imageName)
        //get the image data
        let image = imageView.image
        let imageData = image?.pngData()
        
        //file manager create the file
        let manager = FileManager.default
        manager.createFile(atPath: imagePath, contents: imageData, attributes: nil)
    }
    
    //image picker code
    let imagePicker = UIImagePickerController()
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        //dismiss
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        //extract image from info dict
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        //place image to image view
        imageView.image = image
        //finish the picker
        dismiss(animated: true, completion: nil)
    }
    
    
    //outlets and actions
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var contactTextField: UITextField!
    @IBOutlet weak var detailView: UITextView!
   
    @IBOutlet weak var imageTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    //add photo action
    @IBAction func addPhotoAction(_ sender: Any) {
        //make the attributes of image picker
        imagePicker.delegate = self
        imagePicker.sourceType = .savedPhotosAlbum
        imagePicker.allowsEditing = false
        //present the picker
        present(imagePicker, animated: true, completion: nil)
    }
    
    //cancel button action
    @IBAction func cancelButtonAction(_ sender: UIBarButtonItem) {
        let presentingMode = presentingViewController is UINavigationController
        if presentingMode{
            dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    // saving action
    @IBAction func saveButtonAction(_ sender: UIBarButtonItem) {
        //showAlert()
        if pManagedObject == nil{
            saveNewPerson()
        } else {
            updateNewPerson()
        }
        // to go back
        let presentingMode = presentingViewController is UINavigationController
        if presentingMode{
            dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    //function to show an alert message when save button is clicked
//    func showAlert() {
//        let alert = UIAlertController(title: "Message", message: "Successfully Registered", preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: { action in
//            print("Tapped Dismiss")
//        }))
//        
//        present(alert, animated: true)
//    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // fill the fields with pManagedObject data
        if pManagedObject != nil{
        //setup the text fields
            nameTextField.text    = pManagedObject.name
            genderTextField.text  = pManagedObject.gender
            ageTextField.text     = pManagedObject.age
            contactTextField.text = pManagedObject.phone
            detailView.text       = pManagedObject.details
            imageTextField.text   = pManagedObject.image
            //get image
            getImage(imageName: imageTextField.text!)
        }
    }
}
