//
//  PersonTableViewController.swift
//  Assignment02
//
//  Created by C Karthika on 31/03/2022.
//

import UIKit
import CoreData


class PersonTableViewController: UITableViewController, NSFetchedResultsControllerDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var mySearchBar: UISearchBar!
    
    private var people: [People] = []
    private var predicate: NSPredicate?

    // core data objects and functions
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var pEntity : NSEntityDescription! = nil
    var pManagedObject : People! = nil
    var frc : NSFetchedResultsController<NSFetchRequestResult>! = nil
    
    //fetch request
    func makeRequest()->NSFetchRequest<NSFetchRequestResult> {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "People")
        let sorter = NSSortDescriptor(key:"name" , ascending: true)
        request.sortDescriptors = [sorter]
        return request
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mySearchBar.delegate = self
        tableView.delegate   = self
        tableView.dataSource = self
        
        //make frc and set it up with the table
        frc = NSFetchedResultsController(fetchRequest: makeRequest(), managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self

        //fetch
        do{
            try frc.performFetch()
        }catch{
            print("CD cannot fetch")
        }
        //test if frc in empty
        if frc.sections![0].numberOfObjects == 0{
            //get data from the xml
            let xmlData:[Patient]! = PeopleData(fromXML: "patients.xml").data
            //traverse the data and make coredata objects
            for patient in xmlData{
                //make a pManagedobject
                pEntity = NSEntityDescription.entity(forEntityName: "People", in: context)
                pManagedObject = People(entity: pEntity, insertInto: context)

                //populate it with patient data
                pManagedObject.name    = patient.name
                pManagedObject.gender  = patient.gender
                pManagedObject.age     = patient.age
                pManagedObject.phone   = patient.phone
                pManagedObject.details = patient.details
                pManagedObject.image   = patient.image

                //move the image from bundle to documents
                putImage2Documents(name: patient.image)
                //save
                do{
                    try context.save()
                }catch{

                }
            }
        }
    }
    
    
    //for fetching by name on the search bar
    func fetchEntitiesWith() -> [People] {
        people.removeAll()
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "People")
        request.predicate = predicate
        let sorter = NSSortDescriptor(key: "name", ascending: true)
        request.sortDescriptors = [sorter]

        let frc = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self

        do{
            try frc.performFetch()
        } catch {
            print("frc cannot fetch")
        }
        
        if let peopleFetched = frc.sections?[0].objects as? [People] {
            people.append(contentsOf: peopleFetched)
        }
        return people
    }
    
    //fucntion to extract people from the search bar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty {
            predicate = NSPredicate(format: "name contains %@", searchText)
        } else {
            predicate = nil
        }
        tableView.reloadData()
    }
    

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

   override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        //return frc.sections![section].numberOfObjects
        return fetchEntitiesWith().count
   }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)as! PersonTableViewCell

        // Configure the cell...
        pManagedObject = frc.object(at: indexPath) as? People
        cell.personName.text = pManagedObject.name
        cell.personImage.image = getImage(name: pManagedObject.image!)
        //custom cell
        cell.personView.layer.cornerRadius  = cell.personView.frame.height / 2
        cell.personImage.layer.cornerRadius = cell.personImage.frame.height / 2

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func getImage(name:String) -> UIImage!{
        //find the location to documents to save the file
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
        let imagePath = documentsPath.appendingPathComponent(name)
        //get the image from the file and place it to image view
        return UIImage(contentsOfFile: imagePath)
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            pManagedObject = frc.object(at: indexPath) as? People
            context.delete(pManagedObject)

            tableView.reloadData()
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segue2"{
            let indexPath = tableView.indexPath(for: sender as! UITableViewCell)
            
            let destination = segue.destination as! AddPersonViewController
            
            pManagedObject = frc.object(at: indexPath!) as? People
            destination.pManagedObject = pManagedObject
        }
    }

    func putImage2Documents(name:String) {
        //get the image path
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
        let imagePath = documentsPath.appendingPathComponent(name)
        
        //get image from name and generate PNG data
        let image = UIImage(named: name)
        let imageData = image?.pngData()
        
        // save data with file manager in Documents
        //create an instance of FileManager
        //store the image in the document directory via the imagepath
        let manager = FileManager.default
        manager.createFile(atPath: imagePath, contents: imageData, attributes: nil)
    }
    
}

